# Kali-Style ZSH Installer for Ubuntu 24.04  

kali-zsh.sh

A one-shot installer that transforms a fresh Ubuntu 24.04 installation into a Kali-inspired terminal environment using ZSH and Oh My Posh.

## Features

* Installs ZSH
* Sets ZSH as the default shell
* Installs the Kali Oh My Posh theme
* Enables command autosuggestions
* Enables syntax highlighting
* Enables history substring search
* Adds FZF history search with `Ctrl+R`
* Adds Kali-style tab completion menus
* Automatically launches ZSH when installation is complete
* Designed for fresh Ubuntu 24.04 virtual machines

## Requirements

* Ubuntu 24.04 or newer
* Internet connection
* Sudo privileges

## Installation

Make the script executable:

```bash
chmod +x kali-zsh.sh
```

Run the installer:

```bash
./kali-zsh.sh
```

## Included Plugins

### zsh-autosuggestions

Displays command suggestions from shell history as you type.

### zsh-syntax-highlighting

Highlights commands and syntax in real time.

### zsh-history-substring-search

Searches command history using the Up and Down arrow keys.

### FZF

Provides interactive command history search using:

```text
Ctrl+R
```

## Usage

### History Search

Type part of a previous command and press:

```text
Up Arrow
```

### Command History Finder

```text
Ctrl+R
```

### Command Completion Menu

Type part of a command and press:

```text
Tab
```

## Notes

This script is intended for disposable lab environments, virtual machines, and development systems where a Kali-like shell experience is desired without installing Kali Linux itself.

## License

Use, modify, and distribute freely.
