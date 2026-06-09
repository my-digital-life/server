Interactive Bash script to mount Windows CIFS shares on Ubuntu 24.04. Walks you through entering credentials and share details, handles the setup automatically, and spits out a recovery script you can stash for disaster recovery.

## What it does

- Installs `cifs-utils` and `smbclient`
- Prompts for Windows username, password, domain, and share path
- Creates a credentials file under `/etc/samba/`
- Mounts the share to `/mnt/media/<sharename>`
- Adds the mount to `/etc/fstab` for persistence
- Generates a standalone recovery script named `<username>-<<sharename>.sh`

## Usage

```bash
sudo ./winshare.sh
```

Follow the prompts. The script shows PowerShell commands you can run on the Windows host to look up your username, domain, and share details 

## Recovery script

After a successful run, a second script is created in the same directory. This script is fully self-contained — it reinstalls packages, recreates the credentials file, and remounts the share. Keep it somewhere safe. Run it on a fresh install and you're back online in seconds:


## Requirements

    Ubuntu 24.04 (or similar Debian-based system)  
    sudo privileges  
    Network reachability to the Windows host on port 445  

## Troubleshooting

If the mount fails, the script will suggest common fixes:  

    Try DOMAIN\\user or user@domain format for the username  
    Adjust sec= options (ntlm, ntlmssp, krb5)  
    Verify the share exists with smbclient -L <IP> -U <user>  
    Check Windows firewall and share-level permissions  

## Notes

    Credentials are stored in plain text in /etc/samba/ and the recovery script. This is by design for headless recovery. Use at your own risk on untrusted networks.
    The recovery script is generated with chmod +x and is ready to run immediately.
