# SSH Passwordless Setup (Windows to Ubuntu)

This guide helps you configure passwordless SSH authentication from your Windows machine to your Ubuntu VM. This is required to automate scripts without being prompted for a password.

Generate the Key Manually  
Run this simple command in PowerShell:  
PowerShell  

```
ssh-keygen -t ed25519  
```

When you run this, it will prompt you for three things:  
	1. Enter file in which to save the key: Just press Enter (it will default to C:\Users\YourUser\.ssh\id_ed25519).  
	2. Enter passphrase: Leave it empty by just pressing Enter.  
	3. Enter same passphrase again: Leave it empty by pressing Enter again.  
2. Copy the Key to your VM  
Now that the key is generated, we need to copy it. Since the file is named id_ed25519.pub (the default for ed25519 keys), we use that name instead of id_rsa.pub.  

Run this command:  
PowerShell  

```
cat $HOME\.ssh\id_ed25519.pub | ssh ub@192.168.1.155 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

When prompted, type yes (host fingerprint) and enter the current ub password once.	

NOTE: change host name and ip to suit your needs, If you have more than one ssh server just change	

cat $HOME\.ssh\id_ed25519.pub | ssh pi21@192.168.1.21 "mkdir -p.......	

3. Verification  
Once that command completes, try to SSH into the machine:  
PowerShell  

```
ssh ub@192.168.1.155
```

If it logs you straight into the shell without asking for a password, you have successfully set up the secure "handshake" that allows your scripts to run without being blocked by manual authentication.


Troubleshooting:	

If you already have a old logon from making a new VM, you will get a "REMOTE HOST IDENTIFICATION HAS CHANGED" warning. 	

Run	

```
ssh-keygen -R 192.168.1.155
```

in PowerShell to clear the old host key, then repeat the steps above.
