#!/bin/bash
# mint-postinstall
# Purpose:      script to configure Linux Mint post-install
# Author:       nlogozzo
# Copyright:    (c) 2018, nlogozzo, All Rights Reserved
# Date:         20180822
# Licence:      WTFPL

if [ -n "$BASH_VERSION" ]; then
    echo "You are in a Bash shell."
else
    echo "You are not in a Bash shell. Please switch to Bash before running this script."
    exit 1
fi

# First check that we're actually on a Debian family host
if [[ ! -f /etc/debian_version ]]; then
  printf -- '%s\n' "This script is intended for Debian and its derivatives"
  exit 1
fi
printf -- '%s\n' "OK We are in Debian"
 
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
# sudo apt install openssh-server
 
# Next, install our desired packages
printf -- '%s\n' "Install python3"
sudo apt install -y python3
sudo apt install -y python3-pip
sudo apt install -y pipenv
sudo apt install -y python3-venv

printf -- '%s\n' "Install eza"
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

# Install flatpak
# sudo apt install flatpak
 
# Add flathub (if it doesn't already exist)
# sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
 
# Install our desired flatpak packages
# sudo flatpak install 1 2 3
