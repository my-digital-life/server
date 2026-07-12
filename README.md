# Server Scripts Collection

A collection of Linux server setup, customization, networking, SSH, Samba, and shell automation scripts for Ubuntu, Debian, Kali Linux, and similar distributions.

This repository contains scripts that I use to quickly configure new systems, automate repetitive tasks, and create a consistent Linux environment across servers, desktops, virtual machines, and lab environments.

these commands only work if you use your thumbs to type them in  
use at your own risk !!!!  
backup your router first !!!!  
Cross your fingers  

---

## Windows share mount Setup

#####    This script may be broken I'll check some other day

**Script:** [mount-windows-share.sh](https://github.com/my-digital-life/server/blob/main/mount-windows-share.sh)
**Script:** [winshare.sh](https://github.com/my-digital-life/server/blob/main/winshare.sh)
These scripts installs and configures a Samba file server for sharing files between Linux and Windows systems. It can create share mount remote Windows shares, and enable services automatically.

The script contains example usernames, passwords, IP addresses, and share information. Before running the script, review and edit these values to match your environment. Failure to change the default credentials may result in authentication failures or security issues.

### Download, Edit, and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/mount-windows-share.sh
chmod +x mount-windows-share.sh
# edit top lines
nano mount-windows-share.sh
sudo ./mount-windows-share.sh
```

This one is more automated you don't need to edit with nano

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/winshare.sh
chmod +x winshare.sh
sudo ./winshare.sh
```

### Important

Before running the script, verify and update:

* Windows username and password
* Windows domain or workgroup # todo add workgroup to winshare.sh ?
* Windows share path
* IP addresses
* Shared folder names

---

# Samba Share Setup Script

#####  Samba Provisioning Script (Ubuntu 24.04)

Automated Bash script to set up Samba file shares on fresh Ubuntu 24.04 servers. Designed for rapid VM deployment, home labs, and secured internal networks.

---

## What It Does
This script automates the complete installation and configuration of a Samba server. It handles package installation, user creation, directory setup, permission assignment, and SMB service initialization—all in one go.

### Key Features
- **One-Line Setup**: Install dependencies, config, and launch service automatically.
- **Preconfigured Shares**: Creates two folders (`/test` and `/share`) immediately.
- **Easy Credentials**: Default login `user / user` for quick connectivity.
- **Modern Protocol**: Forces **SMB2** protocol for better performance/security balance.
- **Full Permissions**: Sets `777` directory permissions for maximum accessibility.
- **Guest Access**: Enables `guest ok = yes` for connection without passwords.
- **Silent Logs**: Keeps terminal clean during execution using quiet modes (`-qq`).

---

## How to Run
On your target Ubuntu 24.04 server:  
NOTE: Edit file before use, It's hard coded mto test and share

```bash
# 1. Make script executable
chmod +x sambaQ.sh

# 2. Run with root privileges
sudo ./sambaQ.sh
```

##### Easy way
######  Note: sambaQ.sh and sambaK.sh are basically the same K has more error rreporting

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/main/sambaQ.sh
chmod +x sambaQ.sh
sudo ./sambaQ.sh
```

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/main/sambaK.sh
chmod +x sambaK.sh
sudo ./sambaK.sh
```

## Accessing the Shares

After the script completes, connect to:

```text
\\SERVER_IP\test
\\SERVER_IP\share
```

Replace `SERVER_IP` with the IP address displayed by the script.

## Samba Credentials

```text
Username: user
Password: user
```

## Notes

* The existing `/etc/samba/smb.conf` file is backed up before any changes are made.
* Guest access is enabled.
* Files and directories created through these shares use `777` permissions.
* Linux clients can typically connect to these shares without a password.
* Windows 11 may require authentication even when guest access is enabled.

---

## Kali-Style ZSH and Oh My Posh Setup

**Script:** [kali-zsh.sh](https://github.com/my-digital-life/server/blob/main/kali-zsh.sh)

**Documentation:** [README-kali-zsh.md](https://github.com/my-digital-life/server/blob/main/README-kali-zsh.md)

Use zsh2.sh kali-zsh.sh has some root issues  

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/zsh2.sh
chmod +x zsh2.sh
./zsh2.sh
```

zsh2.sh will also ask if you want zsh for more users if present.

This script transforms a standard Linux terminal into a Kali Linux-inspired environment using ZSH and Oh My Posh. It installs required packages, configures themes, improves shell usability, and provides a cleaner and more informative command-line experience.

### Download and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/kali-zsh.sh
chmod +x kali-zsh.sh
./kali-zsh.sh
```

---

## Alias Installer

**Script:** [add-aliases.sh](https://github.com/my-digital-life/server/blob/main/add-aliases.sh)

**Documentation:** [README-add-aliases.md](https://github.com/my-digital-life/server/blob/main/README-add-aliases.md)

This script installs a collection of useful aliases and shell functions commonly used for system administration, package management, networking, troubleshooting, and day-to-day Linux usage. It is intended to save time and reduce repetitive typing.

### Download and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/add-aliases.sh
chmod +x add-aliases.sh
./add-aliases.sh
```

---

## SSH Configuration Script

**Script:** [ssh.sh](https://github.com/my-digital-life/server/blob/main/ssh.sh)

**Documentation:** [README-ssh-sh.md](https://github.com/my-digital-life/server/blob/main/README-ssh-sh.md)

This script automates common SSH server configuration tasks and helps prepare a system for secure remote administration. It is intended to simplify SSH setup and reduce the amount of manual configuration required after a fresh Linux installation.

### Download and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/ssh.sh
chmod +x ssh.sh
sudo ./ssh.sh
```
---
---  
## SSH Passwordless Setup (Windows to Ubuntu) sshpass.md  

[Readme-sshpass.md](https://github.com/my-digital-life/server/blob/main/Readme-sshpass.md)  

---
---  
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

---

## Supporting Files

These files are used by the setup scripts and may also be useful on their own.

### alias

Contains additional shell aliases and helper commands used by the repository.

### terminal-theme-kali

Provides terminal theme settings used by the Kali-style ZSH configuration.

### bash

Helper script used for setup and execution tasks.

### remove

Removal script used to uninstall or clean up ZSH and Oh My Posh configurations.

---

## Documentation

| File                                                                                               | Description                                 |
| -------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| [README-samba-setup.md](https://github.com/my-digital-life/server/blob/main/README-samba-setup.md) | Samba server installation and configuration |
| [README-kali-zsh.md](https://github.com/my-digital-life/server/blob/main/README-kali-zsh.md)       | Kali-style ZSH and Oh My Posh setup         |
| [README-add-aliases.md](https://github.com/my-digital-life/server/blob/main/README-add-aliases.md) | Alias installation and management           |
| [README-ssh-sh.md](https://github.com/my-digital-life/server/blob/main/README-ssh-sh.md)           | SSH setup and configuration                 |

---

## Quick Reference

| Script         | Purpose                             |
| -------------- | ----------------------------------- |
| samba-setup.sh | Configure Samba file sharing        |
| kali-zsh.sh    | Install Kali-style ZSH environment  |
| add-aliases.sh | Install aliases and shell functions |
| ssh.sh         | Configure SSH services              |

---

## Notes

* Review scripts before running them.
* Some scripts require sudo or root privileges.
* Test scripts in a virtual machine before deploying to production systems.
* Update usernames, passwords, IP addresses, hostnames, and environment-specific settings before use.
* Documentation for each script is available in the corresponding README file.

---




## License

Use, modify, and distribute as needed.

No warranty is provided. Review all code before use.


