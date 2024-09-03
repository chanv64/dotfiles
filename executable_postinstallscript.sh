#!/bin/bash
# mint-postinstall
# Purpose:      script to configure Linux Mint post-install
# Author:       nlogozzo
# Copyright:    (c) 2018, nlogozzo, All Rights Reserved
# Date:         20180822
# Licence:      WTFPL

# Function to execute commands for Arch Linux
arch_commands() {
    echo "Arch Linux detected."
    # Make sure timezone is set correctly
    #sudo timedatectl set-timezone Asia/Singapore
    echo "Performing additional Arch-specific actions..."
    # Start by updating everything
    printf -- '%s\n' "Update System Packages"
    sudo pacman -Syu

    # first thing to do is to install yay package manager
    # yay needs git and gcc as pre-requisite
    pacman -Qi gcc &>/dev/null || sudo pacman -S gcc
    pacman -Qi git &>/dev/null || sudo pacman -S git
    command -v yay >/dev/null 2>&1 || { git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si; }

    # assumming here, yay is already installed. For the rest of the packages here, use yay iso pacman
    printf -- '%s\n' "Install SSH server"
    yay -S --noconfirm openssh-server
     
    # Next, install our desired packages
    printf -- '%s\n' "Install python3 and related packages"
    yay -S --noconfirm python3
    yay -S --noconfirm python3-pip
    yay -S --noconfirm python-pipenv
    yay -S --noconfirm python3-venv

    printf -- '%s\n' "Install eza"
    yay -S --noconfirm eza 

    printf -- '%s\n' "Install neovim"
    yay -S --noconfirm curl 
    yay -S --noconfirm wget 
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    # Install kickstart from my repo
    printf -- '%s\n' "Install kickstart from my repo"
    # install dependencies (read the installation notes at https://github.com/chanv64/mykickstart-nvim)
    yay -S --noconfirm make unzip ripgrep
    mkdir -p ~/.config/nvim
    git clone https://github.com/chanv64/mykickstart-nvim.git ~/.config/nvim

    # For mason pyright to work, need nodejs and npm
    # installs nvm (Node Version Manager)
    printf -- '%s\n' "Install nvm (Node Version Manager)"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

    printf -- '%s\n' "After installation script done, reboot and do the following to install node:"
    printf -- '%s\n' "nvm install 20"
    printf -- '%s\n' "verifies the right Node.js version is in the environment"
    printf -- '%s\n' "node -v # should print ver number"
    printf -- '%s\n' "verifies the right npm version is in the environment"
    printf -- '%s\n' "npm -v # should print '10.8.1'"
    # download and install Node.js (you may need to restart the terminal)
    # nvm install 20

    # verifies the right Node.js version is in the environment
    # node -v # should print `v20.16.0`

    # verifies the right npm version is in the environment
    # npm -v # should print `10.8.1`

    printf -- '%s\n' "Then add this to your shell config (~/.bashrc, ~/. zshrc, ...):"
    printf -- '%s\n' 'export PATH="$PATH:/opt/nvim-linux64/bin"'
    export PATH="$PATH:/opt/nvim-linux64/bin"

    printf -- '%s\n' "Install fish shell"
    yay -S --noconfirm fish
    #
    printf -- '%s\n' "After install fish, install starship"
    curl -sS https://starship.rs/install.sh | sh

    printf -- '%s\n' "After install fish, clone dt github to get example fish and starship config"
    mkdir ~/ref
    git clone https://gitlab.com/dwt1/dotfiles.git ~/ref/dt_dotfiles
    mkdir -p ~/.config/fish
    cp ~/ref/dt_dotfiles/.config/fish/config.fish ~/.config/fish
    cp ~/ref/dt_dotfiles/.config/starship.toml ~/.config

    # clone my dotfiles to copy dot_bashrc
    #git clone https://gitlab.com/chanv64/dotfiles.git
    #cp dotfiles/dot_bashrc .bashrc

    # fish uses DT colorscript. Install it
    cd ~/ref
    git clone https://gitlab.com/dwt1/shell-color-scripts.git
    cd shell-color-scripts
    sudo make install
    yay -S --noconfirm zoxide

    # install fzf
    yay -S --noconfirm fzf

    printf -- '%s\n' "Get the JetBrainsMono Nerd Font"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

    printf -- '%s\n' "Lastly, if you want to use your fish shell as permanent shell, execute sudo chsh -s /usr/bin/fish"

    # install chezmoi for dotfiles management
    # need to test this command line - 
    # sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
    yay -S --noconfirm chezmoi
    chezmoi init
    cd ~/.local/share/chezmoi
    git remote add origin https://github.com/chanv64/dotfiles.git
    git pull origin main
    chezmoi apply
    git branch -m master main

    # install neofetch
    yay -S --noconfirm neofetch

    # install terminals
    yay -S --noconfirm kitty
    yay -S --noconfirm alacritty
    yay -S --noconfirm wezterm

    # install other good stuff
    yay -S --noconfirm bat
    yay -S --noconfirm btop
    yay -S --noconfirm htop
    yay -S --noconfirm dust
    yay -S --noconfirm man
    yay -S --noconfirm rsync
    yay -S --noconfirm tmux
    yay -S --noconfirm locate
    sudo updatedb
    yay -S --noconfirm ranger       #filemanager
    yay -S --noconfirm xh           #works like curl

}

# Function to execute commands for Debian
debian_commands() {
    echo "Debian detected."
    # Next, check that we're running with root privileges
    # if [[ ! -w / ]]; then
      # printf -- '%s\n' "This script must be run with root privileges"
      # exit 1
    # fi
    # printf -- '%s\n' "OK You are in root"
     
    # If we're this far, let's define our password hashes
    # shellcheck disable=SC2016
    # rootPwd='$6$srld6f65$PlVsWpDUt99Qkc/l4kxIHntJPhCtx1lbR2BJ270/d5ty2VW0kV0N0tI4KUjE1JtP2uknUu5ucbG.UkPf53Tv.1'
    # userPwd='$6$srld6f65$PlVsWpDUt99Qkc/l4kxIHntJPhCtx1lbR2BJ270/d5ty2VW0kV0N0tI4KUjE1JtP2uknUu5ucbG.UkPf53Tv.1'
     
    ###############################################################################
    # Setup users
     
    # Setup our standard root password
    # echo "root:${rootPwd}" | chpasswd -e
     
    # Add our standard user.
    # useradd -m -c "Full Name" -p "${userPwd}" username
     
    ###############################################################################
    # Software setup
     
    # Start by updating everything
    printf -- '%s\n' "Update System Packages"
    sudo apt update -y && apt upgrade -y

    printf -- '%s\n' "Install SSH server"
    sudo apt install openssh-server
     
    # Next, install our desired packages
    printf -- '%s\n' "Install python3"
    sudo apt install -y python3
    sudo apt install -y python-pip
    sudo apt install -y python-pipenv
    sudo apt install -y python-virtualenv

    printf -- '%s\n' "Install eza"
    sudo apt install -y wget
    sudo apt install -y curl
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza 

    printf -- '%s\n' "Install neovim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    # Install kickstart from my repo
    printf -- '%s\n' "Install kickstart from my repo"
    # install dependencies (read the installation notes at https://github.com/chanv64/mykickstart-nvim)
    sudo apt install -y git make unzip gcc ripgrep
    mkdir -p ~/.config/nvim
    git clone https://github.com/chanv64/mykickstart-nvim.git ~/.config/nvim

    # For mason pyright to work, need nodejs and npm
    # installs nvm (Node Version Manager)
    printf -- '%s\n' "Install nvm (Node Version Manager)"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

    printf -- '%s\n' "After installation script done, reboot and do the following to install node:"
    printf -- '%s\n' "nvm install 20"
    printf -- '%s\n' "verifies the right Node.js version is in the environment"
    printf -- '%s\n' "node -v # should print ver number"
    printf -- '%s\n' "verifies the right npm version is in the environment"
    printf -- '%s\n' "npm -v # should print '10.8.1'"
    # download and install Node.js (you may need to restart the terminal)
    # nvm install 20

    # verifies the right Node.js version is in the environment
    # node -v # should print `v20.16.0`

    # verifies the right npm version is in the environment
    # npm -v # should print `10.8.1`

    printf -- '%s\n' "Then add this to your shell config (~/.bashrc, ~/. zshrc, ...):"
    printf -- '%s\n' 'export PATH="$PATH:/opt/nvim-linux64/bin"'
    export PATH="$PATH:/opt/nvim-linux64/bin"

    printf -- '%s\n' "Install fish shell"
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    sudo apt update
    sudo apt install -y fish
    #
    printf -- '%s\n' "After install fish, install starship"
    curl -sS https://starship.rs/install.sh | sh

    printf -- '%s\n' "After install fish, clone dt github to get example fish and starship config"
    mkdir ~/ref
    git clone https://gitlab.com/dwt1/dotfiles.git ~/ref/dt_dotfiles
    mkdir -p ~/.config/fish
    cp ~/ref/dt_dotfiles/.config/fish/config.fish ~/.config/fish
    cp ~/ref/dt_dotfiles/.config/starship.toml ~/.config

    # fish uses DT colorscript. Install it
    cd ~/ref
    git clone https://gitlab.com/dwt1/shell-color-scripts.git
    cd shell-color-scripts
    sudo make install
    sudo apt install zoxide

    sudo apt install fzf

    printf -- '%s\n' "Get the JetBrainsMono Nerd Font"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

    printf -- '%s\n' "Lastly, if you want to use your fish shell as permanent shell, execute sudo chsh -s /usr/bin/fish"

    # install chezmoi for dotfiles management
    sudo snap install chezmoi --classic
    chezmoi init
    cd ~/.local/share/chezmoi
    git remote add origin https://github.com/chanv64/dotfiles.git
    git pull origin main
    chezmoi apply
    git branch -m master main


    # do this after chezmoi install
    # clone my dotfiles to copy dot_bashrc
    git clone https://gitlab.com/chanv64/dotfiles.git
    #chezmoi -v apply
    # need to test below
    #sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

    # install chezmoi for dotfiles management
    sudo apt install -y neofetch

    # Install flatpak
    # sudo apt install flatpak
     
    # Add flathub (if it doesn't already exist)
    # sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
     
    # Install our desired flatpak packages
    # sudo flatpak install 1 2 3   # Add any other Debian-specific commands here
}



# Function to handle unknown OS
unknown_os() {
    echo "Unknown or unsupported Linux distribution: $ID"
    echo "No specific actions taken."
}

if [ -n "$BASH_VERSION" ]; then
    echo "You are in a Bash shell."
else
    echo "You are not in a Bash shell. Please switch to Bash before running this script."
    exit 1
fi

# First check that we're actually on a Debian family host
#if [[ ! -f /etc/debian_version ]]; then
#  printf -- '%s\n' "This script is intended for Debian and its derivatives"
#  exit 1
#fi
#printf -- '%s\n' "OK We are in Debian"

# Check if /etc/os-release exists
if [ -f /etc/os-release ]; then
    # Source the os-release file to get OS information
    . /etc/os-release

    case "$ID" in
        debian)
            echo "You are on Debian."
            # Perform actions specific to Debian
            debian_commands
            ;;
        arch)
            echo "You are on Arch Linux."
            # Perform actions specific to Arch
            arch_commands
            ;;
        *)
            echo "You are on another Linux distribution: $ID"
            # Perform other actions or do nothing
            echo "Do nothing"
            ;;
    esac
else
    echo "Cannot determine the operating system."
    # Handle the case where /etc/os-release doesn't exist
    echo "Do nothing"
fi
