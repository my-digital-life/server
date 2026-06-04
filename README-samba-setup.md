# README-samba-setup.md

This README applies to the `samba-setup.sh` script.

## What the script does

The script automates the setup of a Samba file server on Ubuntu.

It performs the following tasks:

* Installs Samba and required packages.
* Creates the following shared directories:

  * `/mnt/media/test`
  * `/mnt/media/share`
* Sets read/write permissions on the shared directories.
* Creates a Samba user.
* Configures Samba shares.
* Opens the firewall for Samba.
* Creates a credentials file for a remote Windows share.
* Mounts the Windows share automatically at boot.
* Restarts and enables Samba services.

## Shares Created

Windows systems can access:

* `\\SERVER-IP\test`
* `\\SERVER-IP\share`

Replace `SERVER-IP` with the IP address of the Ubuntu server.

## Windows Share Mount

The script mounts:

\192.168.1.11\stuff

to:

`/mnt/media/stuff`

## Required Changes

Before running the script, review and change any passwords marked with asterisks (`***`).

Example:

```text
password=***
```

Do not leave example passwords in place on production systems.

Also verify the following values match your environment:

* Windows share IP address
* Windows share name
* Windows username
* Windows password
* Windows domain/workgroup
* Samba username and password

## Usage

Make the script executable:

```bash
chmod +x samba-setup.sh
```

Run the script as root or with sudo:

```bash
sudo ./samba-setup.sh
```

## Notes

This script is intended for trusted home or lab networks.

Review the Samba configuration and permissions before using it on any network that is accessible by untrusted users.
