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


share-maker2.sh

```bash
curl -sSL https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/share-maker2.sh | sudo bash
```

Alternatively, download, make executable, and run locally:

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/share-maker2.sh
chmod +x share-maker2.sh
./share-maker2.sh
```

share-maker.sh


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

# Auto-Detection & Preservation Feature

The script includes smart auto-detection capabilities that make re-running it seamless without breaking your existing setup or credentials.


## 📋 Interactive Prompts Overview

When executed, the script guides you through the following prompts:

1. **Domain/Workgroup Name:** Press `Enter` to accept `WORKGROUP` or type your network domain.
2. **Samba Username:** Press `Enter` for default (`user`) or type a custom username.
3. **Samba Password:** Press `Enter` for default (`user`) or type a custom password.
4. **Number of Shares:** Specify how many folders you want to create (e.g., `3`).
5. **Share Names:** Enter the desired folder names for each share (e.g., `Movies`, `TV`, `Documents`).

# Auto-Detection & Preservation Feature

The script includes smart auto-detection capabilities that make re-running it seamless without breaking your existing setup or credentials.

## What's New

### 🔍 Automatic Configuration Detection
* **Existing Workgroup/Domain:** Scans `/etc/samba/smb.conf` on launch to detect your active Workgroup name and sets it as the default prompt value.
* **Existing Username:** Identifies existing SMB user configurations (`force user`) and suggests your current username as the default.

### 🔑 Password Preservation
* **Keep Existing Credentials:** If the selected Samba user already exists on the Linux system, you can press **`Enter`** to leave the password field blank.
* **No Accidental Reset:** Leaving the password blank instructs the script to bypass `chpasswd` and `smbpasswd`, leaving your existing user password completely untouched and functional.

---

## 🖥️ Example Usage

```text
Root privileges are required to configure Samba.
Prompting for sudo access...
[sudo] password for ubuntu:

Enter Domain/Workgroup name [WORKGROUP]: 
Enter Samba Username [user]: mediaadmin
Enter Samba Password [user]: 
How many shares/folders would you like to create? 2
Enter name for Share #1: Movies
Enter name for Share #2: Downloads

=== Starting Samba Setup... ===
...
=== Setup Complete ===
======================================
Workgroup / Domain:
  WORKGROUP

Folders & Access URLs (Windows):
  - /mnt/media/Movies
    \\192.168.1.100\Movies
  - /mnt/media/Downloads
    \\192.168.1.100\Downloads

Credentials:
  Username: mediaadmin
  Password: user
======================================
✓ Samba service is running!
```

---

## 📁 File Structure

The script creates shares under `/mnt/media/`:

```text
/mnt/media/
├── Share1/
├── Share2/
└── ...
```

---

## 🔧 Requirements

* **OS:** Ubuntu Server 24.04 LTS (or compatible Debian/Ubuntu derivatives)
* **Privileges:** `sudo` access or root user

---

## Example Prompt Flow

```text
Enter Domain/Workgroup name [WORKGROUP]: 
Enter Samba Username [user]: 
Enter Samba Password (leave blank to keep existing password): 
How many shares/folders would you like to create? 1
Enter name for Share #1: media2
