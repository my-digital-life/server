# Kali-Style ZSH Aliases  

This script installs a collection of useful aliases and shell functions commonly used for system administration, package management, networking, troubleshooting, and day-to-day Linux usage. It is intended to save time and reduce repetitive typing.

### Download and Run

```bash
curl -O https://raw.githubusercontent.com/my-digital-life/server/refs/heads/main/add-aliases.sh
chmod +x add-aliases.sh
./add-aliases.sh
```

## Features

### File Operations

Safer file management commands:

* `cp` → prompts before overwrite
* `mv` → prompts before overwrite
* `rm` → prompts before deletion

### Directory Navigation

Quick directory traversal:

```text
..
...
....
```

### Package Management

Update and maintain Ubuntu systems:

```text
update
fullupdate
cleanup
install <package>
remove <package>
search <package>
```

Examples:

```bash
update
fullupdate
install nmap
search docker
```

### File Listings

Improved directory listings:

```text
l
la
ll
```

### Networking

Useful networking commands:

```text
ports
myip
localip
```

### Process Management

View running processes:

```text
psa
```

### Shell Management

Manage and reload ZSH:

```text
reload
zshconfig
aliases
shell
zver
```

### Git Shortcuts

Common Git commands:

```text
gs
ga
gc
gp
gl
```

## Functions

### mkcd

Create and enter a directory in a single command.

Example:

```bash
mkcd projects
```

### extract

Extract common archive formats automatically.

Supported formats:

* zip
* tar
* tar.gz
* tgz
* tar.bz2
* bz2
* gz
* rar
* 7z

Example:

```bash
extract tools.zip
```

## Requirements

* Ubuntu 24.04 or newer
* ZSH
* FZF (optional but recommended)

## Installation

Run:

```bash
chmod +x add-aliases.sh
./add-aliases.sh
```

The script automatically updates `.zshrc` and reloads the shell configuration.

## Purpose

These aliases are intended for lab environments, virtual machines, home labs, development systems, and security testing workstations where quick command-line access is preferred over typing lengthy commands repeatedly.
