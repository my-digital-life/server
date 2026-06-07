#!/bin/bash
set -e

# --- CHECK FOR ROOT/SUDO ACCESS ---
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (use 'sudo')."
  exit 1
fi

# --- CONFIGURATION ---
SMB_USER="user"
SMB_PASS="user"
WORKGROUP="TOKEN"       # Workgroup name
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
log_step "Configuring Samba User '$SMB_USER'..."

if ! id "${SMB_USER}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "${SMB_USER}"
fi

# Set Linux password
echo "${SMB_USER}:${SMB_PASS}" | chpasswd

# Set Samba password
(echo "${SMB_PASS}"; echo "${SMB_PASS}") | smbpasswd -a -s "${SMB_USER}" >/dev/null 2>&1 || true
smbpasswd -e "${SMB_USER}" >/dev/null 2>&1 || true

# --- PERMISSIONS (777 Restored) ---
log_step "Setting Permissions (777)..."
chown -R ${SMB_USER}:${SMB_USER} "${MEDIA_BASE}"
chmod -R 777 "${SHARE_PATH_1}"
chmod -R 777 "${SHARE_PATH_2}"

setfacl -R -m u::rwx,g::rwx,o::rwx "${SHARE_PATH_1}" "${SHARE_PATH_2}"
setfacl -R -d -m u::rwx,g::rwx,o::rwx "${SHARE_PATH_1}" "${SHARE_PATH_2}"

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

# --- SERVICE START ---
log_step "Restarting Samba Service..."
systemctl restart smbd 2>/dev/null || systemctl restart smbd
systemctl enable smbd

# --- NETWORK DETECTION ---
LAN_IP=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $7}' | head -n1)
if [ -z "${LAN_IP}" ]; then
    LAN_IP=$(hostname -I | awk '{print $1}')
fi

# --- FIX: CONSTRUCT PROPER WINDOWS PATHS ---
# We build these strings FIRST so printf doesn't mess up the backslashes or 't'
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
printf '  %s\n' "$TEST_URL"
printf '  %s\n' "$SHARE_URL"
echo ""
echo "Credentials:"
echo "  Username: ${SMB_USER}"
echo "  Password: ${SMB_PASS}"
echo "======================================"

# Check if smbd is running
if systemctl is-active --quiet smbd; then
    echo "✓ Samba service is running!"
else
    echo "⚠ Warning: Samba service might not be running."
    echo "  Run 'journalctl -u smbd' to check errors."
fi
