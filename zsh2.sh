#!/bin/bash

# ==========================================
# ROOT-SAFE MULTI-USER ZSH INSTALLER
# Ubuntu 24.04+
# Installs ZSH + Oh-My-Posh for ALL real users
# WITHOUT touching root
# ==========================================

set -e

if [ "$EUID" -eq 0 ]; then
  echo "Do NOT run this script as root."
  echo "Run it as a normal user (e.g., pi20)."
  exit 1
fi

echo ">>> Updating packages..."
sudo apt update

echo ">>> Installing required packages..."
sudo apt install -y zsh git curl wget unzip fzf fonts-firacode ca-certificates

ZSH_PATH=$(command -v zsh)

# ------------------------------------------
# Function: Install ZSH config for a user
# ------------------------------------------
install_for_user() {
  USERNAME="$1"
  USERHOME=$(eval echo "~$USERNAME")

  echo ">>> Installing ZSH for user: $USERNAME"

  # Create user directories
  sudo -u "$USERNAME" mkdir -p "$USERHOME/.local/bin"
  sudo -u "$USERNAME" mkdir -p "$USERHOME/.cache/oh-my-posh/themes"

  # Install Oh My Posh
  sudo -u "$USERNAME" wget -q -O "$USERHOME/.local/bin/oh-my-posh" \
    https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
  sudo chmod +x "$USERHOME/.local/bin/oh-my-posh"

  # Plugins
  sudo -u "$USERNAME" git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    "$USERHOME/.zsh-autosuggestions"
  sudo -u "$USERNAME" git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$USERHOME/.zsh-syntax-highlighting"
  sudo -u "$USERNAME" git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search \
    "$USERHOME/.zsh-history-substring-search"

  # Theme
  sudo -u "$USERNAME" wget -q -O "$USERHOME/.cache/oh-my-posh/themes/kali.omp.json" \
    https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/kali.omp.json

  # .zshrc
  sudo -u "$USERNAME" bash -c "cat > $USERHOME/.zshrc" << 'EOF'
export PATH="$HOME/.local/bin:$PATH"

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
EOF

  # Set default shell
  sudo chsh -s "$ZSH_PATH" "$USERNAME"

  echo ">>> ZSH installed for $USERNAME"
}

# ------------------------------------------
# Detect all real users (UID >= 1000)
# Excluding: nobody, root
# ------------------------------------------
REAL_USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

echo ">>> Users detected:"
echo "$REAL_USERS"
echo

# ------------------------------------------
# Install ZSH for each user
# ------------------------------------------
for U in $REAL_USERS; do
  install_for_user "$U"
done

echo
echo "=========================================="
echo "ZSH installed for all real users."
echo "Root was NOT modified."
echo "=========================================="
echo
echo "Log out and back in to activate ZSH."
