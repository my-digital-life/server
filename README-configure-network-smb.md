# Configure Network & Samba

A simple script that performs basic network and Samba configuration tasks on Linux systems.

## What It Does

- Ensures the system hostname ends with `.lan`
- Creates a timestamped backup of the existing Samba configuration
- Sets the Samba workgroup to `TOKEN`
- Restarts the Samba service to apply the changes

> **Note:** This script must be run with root privileges. A backup of your existing Samba configuration is created automatically before any modifications are made.

## Installation & Usage

Copy and paste the following commands:

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/main/configure_network_smb.sh
chmod +x configure_network_smb.sh
sudo ./configure_network_smb.sh
```

## Samba Configuration Backup

Before making changes, the script creates a backup similar to:

```text
/etc/samba/smb.conf.bak.YYYYMMDD_HHMMSS
```

## Requirements

- Linux
- Samba installed
- Root privileges (`sudo`)

## Repository

https://github.com/my-digital-life/server

## Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/configure_network_smb.sh
chmod +x configure_network_smb.sh
sudo ./configure_network_smb.sh
```
