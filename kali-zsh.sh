#!/bin/bash

# ==========================================

# GOLDEN IMAGE

# KALI-LIKE ZSH + OH-MY-POSH INSTALLER

# Ubuntu 24.04+

# ==========================================

set -e

echo ">>> Requesting sudo authentication..."
sudo -v

# Keep sudo alive

while true; do
sudo -n true
sleep 60
kill -0 "$$" || exit
done 2>/dev/null &

KEEPALIVE_PID=$!
trap 'kill $KEEPALIVE_PID 2>/dev/null' EXIT

echo ">>> Updating package lists..."
sudo apt update

echo ">>> Installing required packages..."
sudo apt install -y zsh git curl wget unzip fzf fonts-firacode ca-certificates

echo ">>> Verifying ZSH installation..."
ZSH_PATH=$(command -v zsh)

if [ -z "$ZSH_PATH" ]; then
echo "ERROR: ZSH was not installed."
exit 1
fi

echo ">>> Installing Oh My Posh..."
mkdir -p "$HOME/.local/bin"

wget -q -O "$HOME/.local/bin/oh-my-posh" "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"

chmod +x "$HOME/.local/bin/oh-my-posh"

if [ ! -x "$HOME/.local/bin/oh-my-posh" ]; then
echo "ERROR: Oh My Posh installation failed."
exit 1
fi

echo ">>> Installing plugins..."

rm -rf "$HOME/.zsh-autosuggestions"
rm -rf "$HOME/.zsh-syntax-highlighting"
rm -rf "$HOME/.zsh-history-substring-search"

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh-autosuggestions"
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh-syntax-highlighting"
git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search "$HOME/.zsh-history-substring-search"

echo ">>> Downloading Kali theme..."

mkdir -p "$HOME/.cache/oh-my-posh/themes"

wget -q -O "$HOME/.cache/oh-my-posh/themes/kali.omp.json" "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/kali.omp.json"

if [ ! -f "$HOME/.cache/oh-my-posh/themes/kali.omp.json" ]; then
echo "ERROR: Kali theme download failed."
exit 1
fi

echo ">>> Creating .zshrc..."

cat > "$HOME/.zshrc" << 'EOF'
export PATH="$HOME/.local/bin:$PATH"

# HISTORY

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# SHELL OPTIONS

setopt AUTO_CD
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# COMPLETION

autoload -Uz compinit
compinit

zmodload zsh/complist

bindkey '^I' complete-word

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ''

# OH MY POSH

eval "$($HOME/.local/bin/oh-my-posh init zsh --config ~/.cache/oh-my-posh/themes/kali.omp.json)"

# PLUGINS

source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# FZF

[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# HISTORY SEARCH

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# CTRL-R

bindkey '^R' fzf-history-widget
EOF

echo ">>> Configuring login shell..."

if ! grep -q "^$ZSH_PATH$" /etc/shells; then
echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

sudo chsh -s "$ZSH_PATH" "$USER"

echo
echo "=========================================="
echo "INSTALLATION COMPLETE"
echo "=========================================="
echo
echo "Launching Kali-style ZSH..."
sleep 2

exec "$ZSH_PATH"
