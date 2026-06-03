#!/bin/bash

echo ">>> Installing Kali-style aliases and functions..."

# Remove old block if it exists

sed -i '/# BEGIN KALI ALIASES/,/# END KALI ALIASES/d' ~/.zshrc

cat >> ~/.zshrc << 'EOF'

# BEGIN KALI ALIASES

# ==========================================

# KALI-STYLE ALIASES

# ==========================================

# Safer file operations

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Better ls

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Navigation

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Package Management

alias update='sudo apt update && sudo apt upgrade -y'
alias fullupdate='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'

alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'

# Networking

alias ports='ss -tulpen'
alias myip='curl -s ifconfig.me'
alias localip='ip addr show'

# Disk Usage

alias df='df -h'
alias du='du -h'

# Process Viewing

alias psa='ps auxf'

# Grep Colors

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Convenience

alias cls='clear'
alias reload='source ~/.zshrc'

# ZSH Management

alias zshconfig='nano ~/.zshrc'
alias aliases='nano ~/.zshrc'
alias shell='echo $SHELL'
alias zver='echo $ZSH_VERSION'

# Git Shortcuts

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# ==========================================

# FUNCTIONS

# ==========================================

# Make directory and enter it

mkcd() {
mkdir -p "$1" && cd "$1"
}

# Extract most common archive formats

extract() {
if [ -f "$1" ]; then
case "$1" in
*.tar.bz2) tar xjf "$1" ;;
*.tar.gz) tar xzf "$1" ;;
*.bz2) bunzip2 "$1" ;;
*.rar) unrar x "$1" ;;
*.gz) gunzip "$1" ;;
*.tar) tar xf "$1" ;;
*.tbz2) tar xjf "$1" ;;
*.tgz) tar xzf "$1" ;;
*.zip) unzip "$1" ;;
*.7z) 7z x "$1" ;;
*) echo "Cannot extract '$1'" ;;
esac
else
echo "'$1' is not a valid file"
fi
}

# END KALI ALIASES

EOF

echo ">>> Reloading ZSH configuration..."

if [ -n "$ZSH_VERSION" ]; then
source ~/.zshrc
else
zsh -c "source ~/.zshrc"
fi

echo
echo "=========================================="
echo "ALIASES INSTALLED"
echo "=========================================="
echo
echo "Useful commands:"
echo "  update"
echo "  fullupdate"
echo "  cleanup"
echo "  install nmap"
echo "  search docker"
echo "  mkcd projects"
echo "  extract archive.zip"
echo "  ports"
echo "  myip"
echo "  zshconfig"
echo "  reload"
echo
echo "Done."
