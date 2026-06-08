#!/bin/bash
set -euo pipefail

# --- CHECK FOR ROOT/SUDO ACCESS ---
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use 'sudo')."
    exit 1
fi

# --- CONFIGURATION ---
SMB_USER="user"
SMB_PASS="user"
WORKGROUP="TOKEN"
MEDIA_BASE="/mnt/media"
SHARE_PATH_1="${MEDIA_BASE}/test"
SHARE_PATH_2="${MEDIA_BASE}/share"

# --- LOGGING FUNCTION ---
log_step() {
    echo "=== $1 ==="
}

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
mkdir -p "${SHARE_PATH_1}" "${SHARE_PATH_2}"

# --- USER MANAGEMENT ---
log_step "Configuring Samba User '${SMB_USER}'..."

if ! id "${SMB_USER}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "${SMB_USER}"
fi

# Set Linux password
echo "${SMB_USER}:${SMB_PASS}" | chpasswd

# Set Samba password (add if new, update if existing)
if ! (echo "${SMB_PASS}"; echo "${SMB_PASS}") | smbpasswd -a -s "${SMB_USER}" >/dev/null 2>&1; then
    (echo "${SMB_PASS}"; echo "${SMB_PASS}") | smbpasswd -s "${SMB_USER}" >/dev/null 2>&1
fi
smbpasswd -e "${SMB_USER}" >/dev/null 2>&1 || true

# --- PERMISSIONS (777) ---
log_step "Setting Permissions (777)..."
chown -R "${SMB_USER}:${SMB_USER}" "${MEDIA_BASE}"
chmod -R 777 "${SHARE_PATH_1}" "${SHARE_PATH_2}"

# Allow setfacl to fail silently in case the FS lacks ACL support
setfacl -R -m u::rwx,g::rwx,o::rwx "${SHARE_PATH_1}" "${SHARE_PATH_2}" || true
setfacl -R -d -m u::rwx,g::rwx,o::rwx "${SHARE_PATH_1}" "${SHARE_PATH_2}" || true

# --- SAMBA CONFIGURATION ---
log_step "Writing Samba Configuration..."

rm -f /etc/samba/smb.conf

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

[test]
    path = ${SHARE_PATH_1}
    browseable = yes
    writable = yes
    guest ok = yes
    read only = no
    force user = ${SMB_USER}
    create mask = 0777
    directory mask = 0777
    force create mode = 0777
    force directory mode = 0777

[share]
    path = ${SHARE_PATH_2}
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
# Robust method: default route interface -> any up interface -> hostname fallback
DEFAULT_IF=$(ip -4 route show default 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' | head -n1)
if [ -n "${DEFAULT_IF}" ]; then
    LAN_IP=$(ip -4 -o addr show "${DEFAULT_IF}" 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -n1)
else
    LAN_IP=$(ip -4 -o addr show up 2>/dev/null | grep -v ' lo ' | awk '{print $4}' | cut -d/ -f1 | head -n1)
fi

if [ -z "${LAN_IP}" ]; then
    LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
fi

# --- CONSTRUCT PROPER WINDOWS PATHS ---
TEST_URL="\\\\${LAN_IP}\\test"
SHARE_URL="\\\\${LAN_IP}\\share"

# --- SUMMARY OUTPUT ---
log_step "Setup Complete"
echo "======================================"
echo "Network Name:"
echo "  ${WORKGROUP}"
echo ""
echo "Folders:"
echo "  ${SHARE_PATH_1}"
echo "  ${SHARE_PATH_2}"
echo ""
echo "Access URL (Windows):"
printf '  %s\n' "${TEST_URL}"
printf '  %s\n' "${SHARE_URL}"
echo ""
echo "Credentials:"
echo "  Username: ${SMB_USER}"
echo "  Password: ${SMB_PASS}"
echo "======================================"

if systemctl is-active --quiet smbd; then
    echo "✓ Samba service is running!"
else
    echo "⚠ Warning: Samba service might not be running."
    echo "  Run 'journalctl -u smbd' to check errors."
fi
