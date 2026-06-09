#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (use sudo)"
  exit
fi

# 1. Ensure hostname ends in .lan
CURRENT_HOSTNAME=$(hostname)
if [[ ! "$CURRENT_HOSTNAME" == *.lan ]]; then
    NEW_HOSTNAME="${CURRENT_HOSTNAME}.lan"
    echo "Changing hostname from $CURRENT_HOSTNAME to $NEW_HOSTNAME..."
    hostnamectl set-hostname "$NEW_HOSTNAME"
else
    echo "Hostname is already $CURRENT_HOSTNAME (correct)."
fi

# 2. Backup and configure Samba
SMB_CONF="/etc/samba/smb.conf"
# Handle location if standard path is different
[ ! -f "$SMB_CONF" ] && SMB_CONF="/etc/smb.conf"

if [ -f "$SMB_CONF" ]; then
    # Create a backup with a timestamp
    BACKUP_FILE="${SMB_CONF}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$SMB_CONF" "$BACKUP_FILE"
    echo "Backup created at $BACKUP_FILE"

    # Update workgroup
    if grep -q "workgroup =" "$SMB_CONF"; then
        sed -i 's/workgroup = .*/workgroup = TOKEN/' "$SMB_CONF"
    else
        sed -i '/\[global\]/a \   workgroup = TOKEN' "$SMB_CONF"
    fi
    echo "Samba workgroup set to TOKEN."

    # Restart Samba to apply changes
    systemctl restart smbd
    echo "Samba service restarted."
else
    echo "Error: Samba configuration file not found at $SMB_CONF."
fi
