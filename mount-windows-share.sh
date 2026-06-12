#!/bin/bash
set -e

###############################################################################
# EDIT THESE VARIABLES BEFORE RUNNING
###############################################################################

# Windows share path (example shown)
WIN_PATH="//192.168.1.10/stuff"

# Windows username
WIN_USER="John"

# Windows password
WIN_PASS="pass"

###############################################################################
# DO NOT EDIT BELOW THIS LINE
###############################################################################

# Extract share name from WIN_PATH
# Example: //192.168.1.11/vmware → vmware
SHARE_NAME=$(basename "$WIN_PATH")

# Local mount point becomes /mnt/media/<share_name>
MOUNT_POINT="/mnt/media/$SHARE_NAME"

echo "=== Using mount point: $MOUNT_POINT ==="

echo "=== Installing required packages ==="
apt update
apt install -y cifs-utils

echo "=== Creating mount point ==="
mkdir -p "$MOUNT_POINT"
chmod 777 "$MOUNT_POINT"

echo "=== Creating credentials file ==="
mkdir -p /etc/samba

cat >/etc/samba/winshare.creds <<EOF
username=$WIN_USER
password=$WIN_PASS
EOF

chmod 600 /etc/samba/winshare.creds

echo "=== Backing up fstab ==="
cp /etc/fstab /etc/fstab.bak.$(date +%F-%H%M%S)

echo "=== Removing old fstab entries for this mount point ==="
sed -i "\|$MOUNT_POINT|d" /etc/fstab

echo "=== Adding new Windows share to fstab ==="
cat >> /etc/fstab <<EOF

$WIN_PATH $MOUNT_POINT cifs credentials=/etc/samba/winshare.creds,uid=1000,gid=1000,file_mode=0777,dir_mode=0777,noperm,_netdev 0 0
EOF

echo "=== Reloading systemd ==="
systemctl daemon-reload

echo "=== Mounting Windows share ==="
mount -a || { echo "Mount failed"; exit 1; }

echo
echo "======================================"
echo "Windows Share Mounted Successfully"
echo "  $WIN_PATH  -->  $MOUNT_POINT"
echo "======================================"
