#!/bin/bash
# https://raw.githubusercontent.com/my-digital-life/ubuntu/refs/heads/main/setup.sh
# curl -L -o setup.sh https://raw.githubusercontent.com/my-digital-life/ubuntu/refs/heads/main/setup.sh && sudo chmod +x setup.sh

# -------------------------------
# Update package lists
sudo apt update
# -------------------------------

# -------------------------------
# Upgrade all packages to latest versions
# -------------------------------
sudo apt -y full-upgrade

# -------------------------------
# Install SSH and OpenSSH server
# -------------------------------

sudo apt -y install openssh-server ssh
# -------------------------------
# Enable root login via SSH
# This modifies the sshd_config file to allow root login
# -------------------------------

sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# -------------------------------
# Start SSH service to apply changes
# -------------------------------
sudo systemctl start ssh.socket && sudo systemctl enable ssh.socket
# sudo systemctl restart ssh

# -------------------------------
echo "[INFO] Setup complete.
# -------------------------------
