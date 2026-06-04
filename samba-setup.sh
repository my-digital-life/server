#!/bin/bash

set -e

echo "=== Installing packages ==="
apt update
apt install -y samba samba-common-bin cifs-utils winbind ufw

echo "=== Creating directories ==="
mkdir -p /mnt/media/test
mkdir -p /mnt/media/share
mkdir -p /mnt/media/stuff

chmod 777 /mnt/media/test
chmod 777 /mnt/media/share
chmod 777 /mnt/media/stuff

echo "=== Creating Samba user ==="

if ! id user >/dev/null 2>&1; then
useradd -m -s /bin/bash user
echo "user:user" | chpasswd
fi

(echo user; echo user) | smbpasswd -a -s user
smbpasswd -e user

echo "=== Creating Windows credentials ==="

cat >/etc/samba/stuff.creds <<EOF
username=Scott
password=****
domain=TOKEN
EOF

chmod 600 /etc/samba/stuff.creds

echo "=== Backing up smb.conf ==="
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak.$(date +%F-%H%M%S)

echo "=== Writing Samba configuration ==="

cat >/etc/samba/smb.conf <<'EOF'
[global]
workgroup = TOKEN
server string = Ubuntu Samba Server
security = user
map to guest = Bad User
server min protocol = SMB2

[test]
path = /mnt/media/test
browseable = yes
writable = yes
guest ok = yes
read only = no
force create mode = 0777
force directory mode = 0777

[share]
path = /mnt/media/share
browseable = yes
writable = yes
guest ok = yes
read only = no
force create mode = 0777
force directory mode = 0777
EOF

echo "=== Configuring automatic mount ==="

grep -q "//192.168.1.11/stuff" /etc/fstab || cat >> /etc/fstab <<EOF

//192.168.1.11/stuff /mnt/media/stuff cifs credentials=/etc/samba/stuff.creds,uid=1000,gid=1000,file_mode=0777,dir_mode=0777,noperm,_netdev 0 0
EOF

echo "=== Testing Samba configuration ==="
testparm -s

echo "=== Restarting services ==="
systemctl enable smbd
systemctl restart smbd

echo "=== Opening firewall ==="
ufw allow samba || true

echo "=== Mounting Windows share ==="
mount -a

echo
echo "======================================"
echo "Setup Complete"
echo
echo "Samba Shares:"
echo "  \\192.168.1.203\test"
echo "  \\192.168.1.203\share"
echo
echo "Samba User:"
echo "  user / user"
echo
echo "Mounted Windows Share:"
echo "  /mnt/media/stuff"
echo "======================================"
