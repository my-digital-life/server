
Backs up /etc/fstab and removes only matching share lines.
Uses secure permissions and checks mount success.
Optionally installs cifs-utils if missing.

### Prompt for Windows share  
Prompts for Windows share path, username, and password (with password hidden).

### Derive share name and default mount point  
Validates inputs and offers sensible defaults.
Creates a unique credentials file per share

### Ensure cifs-utils present  
Install required packages 

### Create mount point

### Backup fstab  

grep -v -F "$MOUNT_POINT" /etc/fstab | grep -v -F "$WIN_PATH" >/tmp/fstab.new || true
mv /tmp/fstab.new /etc/fstab

### Remove existing fstab lines matching this mount point or share path

### Build mount options, include workgroup if provided  
Workgroup prompt kept optional, Deful is WORKGROUP  
If your SMB server uses a non-default workgroup or domain, adding either  
"workgroup=NAME" or "domain=NAME" to the mount options avoids  
authentication failures and name-resolution issues.

### Create restore script

Creates a restore script in the directory where the original script was run, named using the username, share name and timestamp.
The restore script (executable) will recreate the credentials file, restore the /etc/fstab entry, and attempt to mount the share.
The restore script stores full file paths and the (plain-text) password so you can restore automatically later. (It’s created with mode 700 so only root can run/read it.)
