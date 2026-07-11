#!/usr/bin/env bash

set -e

ENV_FILE="$HOME/.config/shell/env"
ALIAS_FILE="$HOME/.config/shell/alias"
FUNC_FILE="$HOME/.config/shell/func"


NVM_PROFILE='
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
'

# --------------------------
# Helper: append only if missing
# --------------------------
append_if_missing() {
    local line="$1"
    local file="$2"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    grep -Fxq "$line" "$file" || printf "%s\n" "$line" >> "$file"
}

# ==========================
# Task Runner
# ==========================

run_task() {
    local title="$1"
    shift

    printf "\n####### %s #######\n\n" "$title"
    export ENV_FILE ALIAS_FILE NVM_PROFILE FUNC_FILE
    bash -c "$(declare -f append_if_missing); $1"

    printf "\n"
}

run_task "CREATE ENV & ALIAS" '
mkdir -p ~/.config/shell
touch "${ENV_FILE}"
touch "${ALIAS_FILE}"
touch "${FUNC_FILE}"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
'

run_task "UPDATING UBUNTU AND IMP LIB" '
sudo apt update
sudo add-apt-repository universe
sudo apt install -y libfuse2t64
sudo apt-get install -y xclip
sudo apt upgrade -y
sudo apt autoremove -y
'

run_task "INSTALL CURL" '
sudo apt  install curl -y
'

run_task "INSTALLING VIM" '
sudo apt install -y vim
'

run_task "INSTALLING GIT" '
sudo apt install -y git
'

run_task "INSTALLING BRAVE" '
curl -fsS https://dl.brave.com/install.sh | sh
'

run_task "INSTALLING VISUAL STUDIO CODE" '
sudo snap install --classic code
'

run_task "INSTALLING NVM AND NODE.JS" '
# Download and install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash


# Create env file if it does not exist
mkdir -p "$(dirname "$ENV_FILE")"
touch "$ENV_FILE"

# Append only once
if ! grep -Fxq "export NVM_DIR=\"$HOME/.nvm\"" "$ENV_FILE"; then
    printf "%s\n" "$NVM_PROFILE" >> "$ENV_FILE"
fi

# Load nvm without restarting the shell
. "$HOME/.nvm/nvm.sh"

# Install latest Node.js v24
nvm install 24
nvm use 24

# Verify installation
echo "Node version: $(node -v)"
echo "npm version: $(npm -v)"
'


run_task "INSTALLING GO" '
set -euo pipefail

GO_VERSION="1.26.4"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"

echo "Installing Go $GO_VERSION..."

# Download if missing
if [ ! -f "$GO_TARBALL" ]; then
    echo "Downloading Go..."
    curl -fLO "$GO_URL"
fi

# Validate download
if [ ! -s "$GO_TARBALL" ]; then
    echo "Download failed"
    exit 1
fi

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$GO_TARBALL"

PROFILE_LINE="export PATH=\$PATH:/usr/local/go/bin"

append_if_missing "$PROFILE_LINE" "$ENV_FILE"

export PATH="$PATH:/usr/local/go/bin"

go version
'

run_task "UPDATING ENV" '
BASH_LINE="[ -f ~/.config/shell/env ] && . ~/.config/shell/env"
BASH_LINE2="[ -f ~/.config/shell/alias ] && . ~/.config/shell/alias"
BASH_LINE3="[ -f ~/.config/shell/func ] && . ~/.config/shell/func"

ZSH_LINE="[[ -f ~/.config/shell/env ]] && source ~/.config/shell/env"
ZSH_LINE2="[[ -f ~/.config/shell/alias ]] && source ~/.config/shell/alias"
ZSH_LINE3="[[ -f ~/.config/shell/func ]] && source ~/.config/shell/func"

# Bash
append_if_missing "$BASH_LINE" ~/.bashrc
append_if_missing "$BASH_LINE2" ~/.bashrc
append_if_missing "$BASH_LINE3" ~/.bashrc

# Zsh
append_if_missing "$ZSH_LINE" ~/.zshrc
append_if_missing "$ZSH_LINE2" ~/.zshrc
append_if_missing "$ZSH_LINE3" ~/.zshrc
'

printf "#############################################\n"
printf "#         SETUP COMPLETED SUCCESSFULLY      #\n"
printf "#############################################\n\n"

echo "Restart your terminal or run:"
echo "source ~/.bashrc"
echo "source ~/.zshrc"
echo "Install https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf"
echo "Install https://chromewebstore.google.com/detail/video-speed-controller/nffaoalbilbmmfgbnbgppjihopabppdk"
echo "Download Obsidian.deb and sudo apt install ./obsidian.deb : https://obsidian.md/download"