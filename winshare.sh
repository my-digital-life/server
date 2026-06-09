#!/bin/bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
script_name="$(basename "$0")"

# ============================================
#  Windows CIFS Share Auto-Mounter
#  Ubuntu 24.04
# ============================================

# --- dependencies ---
echo -n "Running apt update and installing packages... "
apt-get update -qq
apt-get install -y -qq cifs-utils smbclient
echo "done."

echo
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Mount a Windows share to /mnt/media/<sharename>          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# --- username ---
echo "┌─ Username ───────────────────────────────────────────────┐"
echo "│  The Windows account that has access to this share.      │"
echo "│                                                          │"
echo "│  On the Windows host, open PowerShell as Administrator   │"
echo "│  and run this command to see enabled local users:        │"
echo "│                                                          │"
echo "│    Get-LocalUser | Where-Object Enabled -eq 'True'       │"
echo "└──────────────────────────────────────────────────────────┘"
read -rp "  Username: " username

# --- password ---
echo
echo "┌─ Password ───────────────────────────────────────────────┐"
echo "│  The password for the Windows account above.             │"
echo "│                                                          │"
echo "│  If you don't know the password, you can reset it on     │"
echo "│  the Windows host with this PowerShell command:          │"
echo "│                                                          │"
echo "│    net user <username> <newpassword>                     │"
echo "│                                                          │"
echo "│  Example: net user John MyNewPass123                    │"
echo "└──────────────────────────────────────────────────────────┘"
read -rsp "  Password: " password && echo

# --- domain ---
echo
echo "┌─ Domain ─────────────────────────────────────────────────┐"
echo "│  Active Directory domain or WORKGROUP for local accounts.│"
echo "│                                                          │"
echo "│  On the Windows host, run one of these in PowerShell     │"
echo "│  to see the current domain or workgroup:                 │"
echo "│                                                          │"
echo "│    (Get-WmiObject Win32_ComputerSystem).Domain           │"
echo "│    Get-ComputerInfo | Select -ExpandProperty CsDomain    │"
echo "│                                                          │"
echo "│  Leave as WORKGROUP if this is a home PC.                │"
echo "└──────────────────────────────────────────────────────────┘"
read -rp "  Domain [WORKGROUP]: " domain
domain=${domain:-WORKGROUP}

# --- share path ---
echo
echo "┌─ Share Path ─────────────────────────────────────────────┐"
echo "│  Format: IP_ADDRESS/SHARE_NAME                         │"
echo "│  Example: 192.168.1.11/stuff                           │"
echo "│  To list shares from this host: smbclient -L <IP> -N   │"
echo "└──────────────────────────────────────────────────────────┘"
read -rp "  Share path: " sharepath

# --- validate ---
[[ "$sharepath" =~ / ]] || { echo "Error: path must be IP/share"; exit 1; }

sharename="${sharepath##*/}"
mountpoint="/mnt/media/${sharename}"
credfile="/etc/samba/${sharename}.creds"

# --- setup ---
echo
echo -n "Creating directories... "
mkdir -p /etc/samba "$mountpoint"
echo "done."

echo -n "Writing credentials... "
cat > "$credfile" <<EOF
username=${username}
password=${password}
domain=${domain}
EOF
chmod 600 "$credfile"
echo "done."

# --- mount ---
opts="credentials=${credfile},uid=$(id -u),gid=$(id -g),file_mode=0755,dir_mode=0755,_netdev,vers=3.0,sec=ntlmssp"

mountpoint -q "$mountpoint" && umount "$mountpoint" 2>/dev/null || true

echo -n "Mounting //${sharepath}... "
if ! mount -t cifs -o "$opts" "//${sharepath}" "$mountpoint"; then
    echo "failed."
    echo
    echo "Troubleshooting:"
    echo "  • Try username format: ${domain}\\\\${username}  or  ${username}@${domain}"
    echo "  • Try different sec= options: ntlm, ntlmssp, krb5"
    echo "  • Verify share exists: smbclient -L ${sharepath%%/*} -U ${username}"
    echo "  • Check Windows firewall & share permissions"
    exit 1
fi
echo "done."

# --- fstab ---
fstab_entry="//${sharepath} ${mountpoint} cifs ${opts} 0 0"
grep -qF "$fstab_entry" /etc/fstab || echo "$fstab_entry" >> /etc/fstab
systemctl daemon-reload

# --- save replay script ---
safe_name="${username}-${sharename}.sh"
safe_name="${safe_name//\//-}"
replay_path="${script_dir}/${safe_name}"

cat > "$replay_path" <<REPLAY
#!/bin/bash
set -euo pipefail

# ============================================
#  Auto-generated recovery script
#  Created by ${script_name}
# ============================================

echo -n "Installing packages... "
apt-get update -qq
apt-get install -y -qq cifs-utils smbclient
echo "done."

mkdir -p /etc/samba
mkdir -p ${mountpoint}

cat > ${credfile} <<'EOF'
username=${username}
password=${password}
domain=${domain}
EOF
chmod 600 ${credfile}

mountpoint -q ${mountpoint} && umount ${mountpoint} 2>/dev/null || true

echo -n "Mounting //${sharepath}... "
if ! mount -t cifs -o ${opts} //${sharepath} ${mountpoint}; then
    echo "failed."
    exit 1
fi
echo "done."

fstab_entry="//${sharepath} ${mountpoint} cifs ${opts} 0 0"
grep -qF "\${fstab_entry}" /etc/fstab || echo "\${fstab_entry}" >> /etc/fstab
systemctl daemon-reload

echo
echo "Mounted: ${mountpoint}"
df -h ${mountpoint}
ls -la ${mountpoint}
REPLAY

chmod +x "$replay_path"

# --- done ---
echo
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✓ MOUNTED SUCCESSFULLY                                  ║"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║  Share:    //${sharepath}"
echo "║  Local:    ${mountpoint}"
echo "║  User:     ${username}"
echo "║  Domain:   ${domain}"
echo "╠════════════════════════════════════════════════════════════╣"
echo "║  Recovery script saved: ${safe_name}"
echo "╚════════════════════════════════════════════════════════════╝"
echo
df -h "$mountpoint"
echo
ls -la "$mountpoint"
