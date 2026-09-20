# Server Scripts Collection:

A collection of Linux server setup, customization, networking, SSH, Samba, and shell automation scripts for Ubuntu, Debian, Kali Linux, and similar distributions.

This repository contains scripts that I use to quickly configure new systems, automate repetitive tasks, and create a consistent Linux environment across servers, desktops, virtual machines, and lab environments.

these commands only work if you use your thumbs to type them in  
use at your own risk !!!!  
backup your router first !!!!  
Cross your fingers  

---

## Mount Windows share Setup

**Script:** [mount-windows-share.sh](https://github.com/my-digital-life/server/blob/main/mount-windows-share.sh)
**Script:** [winshare.sh](https://github.com/my-digital-life/server/blob/main/winshare.sh)
These scripts installs and configures a Samba file server for sharing files between Linux and Windows systems. It can create share mount remote Windows shares, and enable services automatically.

The script contains example usernames, passwords, IP addresses, and share information. Before running the script, review and edit these values to match your environment. Failure to change the default credentials may result in authentication failures or security issues.  
Both scripts add to fstab and auto mount shares to /mnt/media/`share name` and are mounted after script finishes and also survives reboots

### Download, Edit, and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/mount-windows-share.sh
chmod +x mount-windows-share.sh
# edit top lines
nano mount-windows-share.sh
sudo ./mount-windows-share.sh
```

This one is more automated you don't need to edit with nano, It will prompt for Username,Password and //ip/share-name

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

# Dynamic Samba Share Maker (`share-maker.sh`)

An interactive, automated Bash script designed for Ubuntu Server 24.04 (and other Debian-based distributions) to instantly set up and configure customized Samba network shares.

---

## 🌟 Key Features

* **Auto-Elevation to Root:** Automatically prompts for `sudo` access if executed by a non-root user.
* **Custom Domain/Workgroup Prompt:** Allows custom workgroup/domain naming with a default fallback to `WORKGROUP`.
* **Custom Samba Credentials:** Prompts for custom Samba username and password (defaults to `user` / `user` if skipped).
* **Dynamic Multi-Share Creation:** Specify any number of shares to create at once; the script dynamically creates folders under `/mnt/media/` and mounts them into Samba.
* **Automatic Dependency Management:** Silently installs `samba`, `samba-common-bin`, and `acl` package dependencies.
* **Full RW Permissions:** Automatically manages file permissions (`777`), directory ownership, and POSIX ACLs for seamless cross-network read/write access.
* **Network & Firewall Auto-Detection:** Auto-detects local IPv4 addresses, opens standard Samba ports in `ufw`, and outputs clean Windows UNC file paths (`\\IP\share_name`).

---

## 🚀 One-Liner Quick Run

Run the script directly from GitHub using `curl`:

```bash
curl -sSL https://raw.githubusercontent.com/my-digital-life/server/main/share-maker.sh | sudo bash
```

Alternatively, download, make executable, and run locally:

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/main/share-maker.sh
chmod +x share-maker.sh
./share-maker.sh
```

---

## 📋 Interactive Prompts Overview

When executed, the script guides you through the following prompts:

1. **Domain/Workgroup Name:** Press `Enter` to accept `WORKGROUP` or type your network domain.
2. **Samba Username:** Press `Enter` for default (`user`) or type a custom username.
3. **Samba Password:** Press `Enter` for default (`user`) or type a custom password.
4. **Number of Shares:** Specify how many folders you want to create (e.g., `3`).
5. **Share Names:** Enter the desired folder names for each share (e.g., `Movies`, `TV`, `Documents`).

---

## Kali-Style ZSH and Oh My Posh Setup
##### I like kali-zsh.sh

This script transforms a standard Linux terminal into a Kali Linux-inspired environment using ZSH and Oh My Posh. It installs required packages, configures theme.

### Download and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/kali-zsh.sh
chmod +x kali-zsh.sh
./kali-zsh.sh
```

zsh2.sh  

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/zsh2.sh
chmod +x zsh2.sh
./zsh2.sh
```

zsh2.sh will also ask if you want zsh for more users if present.


## Alias Installer

**Script:** [new-zshrc.sh](https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/new-zshrc.sh)
**Script:** [add-aliases.sh](https://github.com/my-digital-life/server/blob/main/add-aliases.sh)

**Documentation:** [README-add-aliases.md](https://github.com/my-digital-life/server/blob/main/README-add-aliases.md)

This script installs a collection of useful aliases and shell functions commonly used for system administration, package management, networking, troubleshooting, and day-to-day Linux usage. It is intended to save time and reduce repetitive typing.

### Download and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/new-zshrc.sh
chmod +x new-zshrc.sh
./new-zshrc.sh
```


```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/add-aliases.sh
chmod +x add-aliases.sh
./add-aliases.sh
```

---
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

---
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


