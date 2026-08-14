#!/usr/bin/env bash
# nvim_setup
# Purpose: install Neovim + Node toolchain (npm/yarn) and deploy the
#          dotfiles neovim config on a fresh machine.
# Repo:    https://github.com/chanv64/dotfiles
#
# Usage:
#   bash bin/executable_nvim_setup.sh
# or (after `chezmoi apply`) `~/bin/nvim_setup.sh`

set -euo pipefail

REPO_URL="https://github.com/chanv64/dotfiles.git"
REPO_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_SOURCE_DIR="$REPO_DIR/dot_config/neovim"

# Detect the package manager from /etc/os-release (or macOS).
detect_os() {
    pm=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        os_id="$ID ${ID_LIKE:-}"
        case "$os_id" in
            *arch*)   pm="pacman" ;;
            *debian*|*ubuntu*) pm="apt" ;;
            *fedora*|*rhel*|*centos*) pm="dnf" ;;
            *suse*)   pm="zypper" ;;
        esac
    elif command -v sw_vers >/dev/null 2>&1; then
        pm="brew"
    fi
    if [ -z "$pm" ]; then
        echo "Unsupported OS. Install git, neovim, npm, yarn manually." >&2
        exit 1
    fi
    echo "Detected package manager: $pm"
}

install_pkgs() {
    case "$pm" in
        pacman)
            sudo pacman -Syu --noconfirm
            sudo pacman -S --needed --noconfirm git neovim npm yarn
            ;;
        apt)
            sudo apt-get update -y
            sudo apt-get install -y git neovim nodejs npm
            # yarn ships with nodejs via corepack; fall back to npm
            corepack enable 2>/dev/null || sudo npm install -g yarn
            ;;
        dnf)
            sudo dnf install -y git neovim nodejs npm yarnpkg
            ;;
        zypper)
            sudo zypper --non-interactive install git neovim nodejs npm yarn
            ;;
        brew)
            brew install git neovim node yarn
            ;;
    esac
}

clone_repo() {
    if [ -d "$REPO_DIR/.git" ]; then
        echo "Repo already at $REPO_DIR, pulling latest..."
        git -C "$REPO_DIR" pull --ff-only
    else
        git clone "$REPO_URL" "$REPO_DIR"
    fi
}

deploy_config() {
    mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
    if [ -e "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
        local bak="${NVIM_CONFIG_DIR}.bak.$(date +%s)"
        echo "Backing up existing config to $bak"
        mv "$NVIM_CONFIG_DIR" "$bak"
    fi
    echo "Symlinking $NVIM_CONFIG_DIR -> $NVIM_SOURCE_DIR"
    ln -sfn "$NVIM_SOURCE_DIR" "$NVIM_CONFIG_DIR"
}

install_plugins() {
    if command -v nvim >/dev/null 2>&1; then
        echo "Installing plugins (first run)..."
        nvim --headless "+Lazy! sync" +qa || true
    fi
}

main() {
    detect_os
    install_pkgs
    clone_repo
    deploy_config
    install_plugins
    echo "Done. Start neovim with 'nvim'."
}

main "$@"
