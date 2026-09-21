#!/bin/bash
set -euo pipefail

# --- 1. CHECK & ELEVATE TO ROOT IF NOT RUN AS SUDO ---
if [ "$EUID" -ne 0 ]; then
    echo "Root privileges are required to configure Samba."
    echo "Prompting for sudo access..."
    exec sudo "$0" "$@"
    exit 1
fi

# --- LOGGING FUNCTION ---
log_step() {
    echo "=== $1 ==="
}

# --- DETECT EXISTING CONFIGURATION ---
DETECTED_WORKGROUP="WORKGROUP"
DETECTED_USER="user"

if [ -f /etc/samba/smb.conf ]; then
    # Try reading existing workgroup from smb.conf
    EXISTING_WG=$(grep -i "^\s*workgroup\s*=" /etc/samba/smb.conf | head -n1 | awk -F'=' '{print $2}' | xargs || true)
    if [ -n "${EXISTING_WG}" ]; then
        DETECTED_WORKGROUP="${EXISTING_WG}"
    fi

    # Try reading existing force user from smb.conf
    EXISTING_USER=$(grep -i "^\s*force user\s*=" /etc/samba/smb.conf | head -n1 | awk -F'=' '{print $2}' | xargs || true)
    if [ -n "${EXISTING_USER}" ]; then
        DETECTED_USER="${EXISTING_USER}"
    fi
fi

# --- PROMPT FOR WORKGROUP / DOMAIN NAME ---
read -p "Enter Domain/Workgroup name [${DETECTED_WORKGROUP}]: " INPUT_WORKGROUP
WORKGROUP="${INPUT_WORKGROUP:-$DETECTED_WORKGROUP}"

# --- PROMPT FOR USERNAME AND PASSWORD ---
read -p "Enter Samba Username [${DETECTED_USER}]: " INPUT_USER
SMB_USER="${INPUT_USER:-$DETECTED_USER}"

# Check if user already exists in Linux database
USER_EXISTS=false
if id "${SMB_USER}" >/dev/null 2>&1; then
    USER_EXISTS=true
fi

if [ "$USER_EXISTS" = true ]; then
    read -p "Enter Samba Password (leave blank to keep existing password): " INPUT_PASS
    SMB_PASS="${INPUT_PASS:-}"
else
    read -p "Enter Samba Password [user]: " INPUT_PASS
    SMB_PASS="${INPUT_PASS:-user}"
fi

MEDIA_BASE="/mnt/media"

# --- PROMPT FOR NUMBER OF FOLDERS & NAMES ---
while true; do
    read -p "How many shares/folders would you like to create? " SHARE_COUNT
    if [[ "$SHARE_COUNT" =~ ^[1-9][0-9]*$ ]]; then
        break
    else
        echo "Please enter a valid positive number."
    fi
done

# Arrays to store folder names and absolute paths
declare -a FOLDER_NAMES
declare -a SHARE_PATHS

for (( i=1; i<=SHARE_COUNT; i++ )); do
    while true; do
        read -p "Enter name for Share #${i}: " FOLDER_NAME
        # Strip trailing/leading spaces
        FOLDER_NAME=$(echo "$FOLDER_NAME" | xargs)
        if [ -n "$FOLDER_NAME" ]; then
            FOLDER_NAMES+=("$FOLDER_NAME")
            SHARE_PATHS+=("${MEDIA_BASE}/${FOLDER_NAME}")
            break
        else
            echo "Share name cannot be empty."
        fi
    done
done

log_step "Starting Samba Setup..."

# --- UPDATE AND INSTALL PACKAGES ---
log_step "Updating Package Lists (Quiet)..."
apt-get update -qq || true

log_step "Installing Required Packages (Silent)..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    samba \
    samba-common-bin \
    acl > /dev/null 2>&1

# --- DIRECTORIES ---
log_step "Creating Directories..."
mkdir -p "${SHARE_PATHS[@]}"

# --- USER MANAGEMENT ---
log_step "Configuring Samba User '${SMB_USER}'..."

if ! id "${SMB_USER}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "${SMB_USER}"
fi

# Only update passwords if a new password was provided or if user is brand new
if [ -n "${SMB_PASS}" ]; then
    # Set Linux password
    echo "${SMB_USER}:${SMB_PASS}" | chpasswd

    # Set Samba password (add if new, update if existing)
    if ! (echo "${SMB_PASS}"; echo "${SMB_PASS}") | smbpasswd -a -s "${SMB_USER}" >/dev/null 2>&1; then
        (echo "${SMB_PASS}"; echo "${SMB_PASS}") | smbpasswd -s "${SMB_USER}" >/dev/null 2>&1
    fi
    smbpasswd -e "${SMB_USER}" >/dev/null 2>&1 || true
else
    echo "Keeping existing password for user '${SMB_USER}'."
fi

# --- PERMISSIONS (777) ---
log_step "Setting Permissions (777)..."
chown -R "${SMB_USER}:${SMB_USER}" "${MEDIA_BASE}"

for path in "${SHARE_PATHS[@]}"; do
    chmod -R 777 "$path"
    # Allow setfacl to fail silently in case the FS lacks ACL support
    setfacl -R -m u::rwx,g::rwx,o::rwx "$path" || true
    setfacl -R -d -m u::rwx,g::rwx,o::rwx "$path" || true
done

# --- SAMBA CONFIGURATION ---
log_step "Writing Samba Configuration..."

# Create smb.conf with [global] ONLY if it does not already exist
if [ ! -f /etc/samba/smb.conf ]; then
cat > /etc/samba/smb.conf << EOF
[global]
    workgroup = ${WORKGROUP}
    server string = Ubuntu Samba Share
    security = user
    map to guest = Bad User
    server min protocol = SMB2
    dns proxy = no
    log level = 1
    passdb backend = tdbsam
EOF
fi

# Append share configurations dynamically without duplicating existing ones
for i in "${!FOLDER_NAMES[@]}"; do
    SHARE_NAME="${FOLDER_NAMES[$i]}"

    if grep -q "^\\[${SHARE_NAME}\\]" /etc/samba/smb.conf; then
        echo "Note: Share [${SHARE_NAME}] already exists in /etc/samba/smb.conf. Skipping entry addition."
    else
        cat >> /etc/samba/smb.conf << EOF

[${SHARE_NAME}]
    path = ${SHARE_PATHS[$i]}
    browseable = yes
    writable = yes
    guest ok = yes
    read only = no
    force user = ${SMB_USER}
    create mask = 0777
    directory mask = 0777
    force create mode = 0777
    force directory mode = 0777
EOF
    fi
done

# Validate config before restarting
if ! testparm -s /etc/samba/smb.conf >/dev/null 2>&1; then
    echo "Error: smb.conf failed validation. Check /etc/samba/smb.conf"
    exit 1
fi

# --- SERVICE START ---
log_step "Restarting Samba Services..."
systemctl restart smbd nmbd
systemctl enable smbd nmbd

# --- FIREWALL (best effort) ---
ufw allow samba >/dev/null 2>&1 || true

# --- NETWORK DETECTION ---
DEFAULT_IF=$(ip -4 route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -n1)
if [ -n "${DEFAULT_IF}" ]; then
    LAN_IP=$(ip -4 -o addr show "${DEFAULT_IF}" 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -n1)
else
    LAN_IP=$(ip -4 -o addr show up 2>/dev/null | grep -v ' lo ' | awk '{print $4}' | cut -d/ -f1 | head -n1)
fi

if [ -z "${LAN_IP}" ]; then
    LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
fi

# --- SUMMARY OUTPUT ---
log_step "Setup Complete"
echo "======================================"
echo "Workgroup / Domain:"
echo "  ${WORKGROUP}"
echo ""
echo "New Folders & Access URLs (Windows):"
for name in "${FOLDER_NAMES[@]}"; do
    echo "  - ${MEDIA_BASE}/${name}"
    echo "    \\\\${LAN_IP}\\${name}"
done
echo ""
echo "Credentials:"
echo "  Username: ${SMB_USER}"
if [ -n "${SMB_PASS}" ]; then
    echo "  Password: ${SMB_PASS}"
else
    echo "  Password: [UNCHANGED / EXISTING]"
fi
echo "======================================"

if systemctl is-active --quiet smbd; then
    echo "✓ Samba service is running!"
else
    echo "⚠ Warning: Samba service might not be running."
    echo "  Run 'journalctl -u smbd' to check errors."
fi
