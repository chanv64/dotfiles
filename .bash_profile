export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
eval "$(/opt/homebrew/bin/brew shellenv)"
alias python=/opt/homebrew/bin/python3
export PATH=~/.local/bin:~/bin:~/Library/Python/3.11/bin:$PATH
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
