# Server Scripts Collection

A collection of Linux server setup, customization, networking, SSH, Samba, and shell automation scripts for Ubuntu, Debian, Kali Linux, and similar distributions.

---

## Repository

https://github.com/my-digital-life/server

---

## Available Scripts

### Samba Server Setup

Automatically installs and configures Samba for Windows and Linux file sharing.

**Script:** [`samba-setup.sh`](https://github.com/my-digital-life/server/blob/main/samba-setup.sh)

**Documentation:** [`README-samba-setup.md`](https://github.com/my-digital-life/server/blob/main/README-samba-setup.md)

Features:

* Installs Samba and required packages
* Creates shared folders
* Creates Samba users
* Configures Samba shares
* Mounts Windows shares
* Enables automatic startup

---

### Kali-Style ZSH and Oh My Posh Setup

Installs and configures a Kali Linux style terminal environment with ZSH and Oh My Posh.

**Script:** [`kali-zsh.sh`](https://github.com/my-digital-life/server/blob/main/kali-zsh.sh)

**Documentation:** [`README-kali-zsh.md`](https://github.com/my-digital-life/server/blob/main/README-kali-zsh.md)

Features:

* Installs ZSH
* Installs Oh My Posh
* Configures shell themes
* Creates a Kali-style terminal experience

---

### Alias Installer

Installs a collection of useful aliases and shell functions for Linux administration.

**Script:** [`add-aliases.sh`](https://github.com/my-digital-life/server/blob/main/add-aliases.sh)

**Documentation:** [`README-add-aliases.md`](https://github.com/my-digital-life/server/blob/main/README-add-aliases.md)

Features:

* Package management shortcuts
* Networking shortcuts
* System administration helpers
* ZSH-friendly functions

---

### SSH Configuration Script

Utility script for SSH setup and configuration.

**Script:** [`ssh.sh`](https://github.com/my-digital-life/server/blob/main/ssh.sh)

**Documentation:** [`README-ssh-sh.md`](https://github.com/my-digital-life/server/blob/main/README-ssh-sh.md)

Features:

* SSH configuration automation
* Common SSH management tasks

---

### Terminal Theme Configuration

Additional terminal theme configuration files.

**File:** [`terminal-theme-kali`](https://github.com/my-digital-life/server/blob/main/terminal-theme-kali)

Features:

* Terminal appearance customization
* Kali-style visual configuration

---

### Alias Collection

Additional alias definitions used by the setup scripts.

**File:** [`alias`](https://github.com/my-digital-life/server/blob/main/alias)

Features:

* Command shortcuts
* Administrative helper commands

---

### Script Runner

Helper script used for executing setup tasks.

**File:** [`bash`](https://github.com/my-digital-life/server/blob/main/bash)

Features:

* Script execution helpers
* Setup automation support

---

### Removal Script

Removes ZSH and Oh My Posh configurations installed by the setup scripts.

**File:** [`remove`](https://github.com/my-digital-life/server/blob/main/remove)

Features:

* Uninstalls Oh My Posh
* Removes custom ZSH configuration
* Restores a cleaner shell environment

---

## Documentation

| Documentation                                                                                      | Description                         |
| -------------------------------------------------------------------------------------------------- | ----------------------------------- |
| [README-samba-setup.md](https://github.com/my-digital-life/server/blob/main/README-samba-setup.md) | Samba server setup instructions     |
| [README-kali-zsh.md](https://github.com/my-digital-life/server/blob/main/README-kali-zsh.md)       | Kali-style ZSH and Oh My Posh setup |
| [README-add-aliases.md](https://github.com/my-digital-life/server/blob/main/README-add-aliases.md) | Alias installation and management   |
| [README-ssh-sh.md](https://github.com/my-digital-life/server/blob/main/README-ssh-sh.md)           | SSH setup and configuration         |

---

## Quick Start

Clone the repository:

```bash
git clone https://github.com/my-digital-life/server.git
cd server
```

Make a script executable:

```bash
chmod +x script-name.sh
```

Run the script:

```bash
sudo ./script-name.sh
```

---

## Notes

* Review all scripts before running them.
* Some scripts require root or sudo privileges.
* Test in a virtual machine before deploying to production systems.
* Update usernames, passwords, IP addresses, hostnames, and other environment-specific settings before use.

---

## License

Use, modify, and distribute as needed.

No warranty is provided. Review all code before use.
