#!/bin/bash

set -e

echo "=== Installing packages ==="
apt update -qq
apt install -y -qq samba samba-common-bin acl

echo "=== Creating directories ==="
mkdir -p /mnt/media/test
mkdir -p /mnt/media/share

echo "=== Creating Samba user ==="

if ! id user >/dev/null 2>&1; then
useradd -m -s /bin/bash user
echo "user" | chpasswd
fi

(echo user; echo user) | smbpasswd -a -s user >/dev/null 2>&1 || true
smbpasswd -e user

echo "=== Setting ownership and permissions ==="

chown -R user /mnt/media/test
chown -R user /mnt/media/share

chmod -R 777 /mnt/media/test
chmod -R 777 /mnt/media/share

# Existing files and directories

setfacl -R -m u::rwx,g::rwx,o::rwx /mnt/media/test
setfacl -R -m u::rwx,g::rwx,o::rwx /mnt/media/share

# Future files and directories

setfacl -R -d -m u::rwx,g::rwx,o::rwx /mnt/media/test
setfacl -R -d -m u::rwx,g::rwx,o::rwx /mnt/media/share

echo "=== Backing up smb.conf ==="
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak.$(date +%F-%H%M%S)

echo "=== Writing Samba configuration ==="

cat > /etc/samba/smb.conf << 'EOF'
[global]
workgroup = WORKGROUP
server string = Kali
security = user
map to guest = Bad User
server min protocol = SMB2

[test]
path = /mnt/media/test
browseable = yes
writable = yes
guest ok = yes
read only = no
force user = user
create mask = 0777
directory mask = 0777
force create mode = 0777
force directory mode = 0777

[share]
path = /mnt/media/share
browseable = yes
writable = yes
guest ok = yes
read only = no
force user = user
create mask = 0777
directory mask = 0777
force create mode = 0777
force directory mode = 0777
EOF

echo "=== Testing Samba configuration ==="
testparm -s >/dev/null

echo "=== Restarting Samba ==="
systemctl enable smbd
systemctl restart smbd

IP=$(hostname -I | awk '{print $1}')

echo
echo "======================================"
echo "Setup Complete"
echo

echo "Folders:"
echo "  /mnt/media/test"
echo "  /mnt/media/share"
echo

echo "Samba Shares:"
printf '  \\\\%s\\test\n' "$IP"
printf '  \\\\%s\\share\n' "$IP"
echo

echo "Samba User:"
echo "  user / user"
echo

echo "To view network interfaces:"
echo "  ip -br a | grep UP"
echo

echo "To view share contents:"
echo "  ls -lah /mnt/media/share"
echo

echo "======================================"
