````markdown
# Server  
Setting Kali Linux Theme on Ubuntu

---

## Tested on Ubuntu Server

- ubuntu-24.04.4-live-server-amd64.iso  
- ubuntu-24.04.3-live-server-amd64.iso  (VM)

## Tested on Kubuntu

- kubuntu-24.04.4-desktop-amd64.iso  (VM)

---

# 🧹 Uninstall

If you want to completely remove the Kali‑style ZSH environment installed by this script, use the commands below.

This will remove:

- Oh‑My‑Posh binary  
- Oh‑My‑Posh theme  
- ZSH plugins  
- Generated `.zshrc`  
- FZF ZSH bindings (only the sourced ones)  
- ZSH as your default shell (switches back to Bash)

It does **NOT** remove system packages like `zsh`, `fzf`, or fonts — those are safe to keep and used by many tools.

---

## Notes

This uninstall does **not** delete your ZSH history file (`~/.zsh_history`).  
If you want to remove it too:

```rm -f ~/.zsh_history```

If you manually added additional plugins or themes, remove them separately.

If you want to remove ZSH entirely:

```sudo apt remove --purge -y zsh```


