# Function to get the current git branch
parse_git_branch() {
    git branch 2>/dev/null | grep -e '^*' | sed 's/^* //'
}

# Customize the PS1 variable to include the git branch
#PS1='\u@\h:\w$(if [ -d .git ]; then echo " [$(parse_git_branch)]"; fi)\$ '

# Add color to the prompt
# blue for current directory
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(if [ -d .git ]; then echo " [$(parse_git_branch)]"; fi)\[\033[00m\]\$ '
# white for current directory
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\[\033[01;33m\]$(if [ -d .git ]; then echo " [$(parse_git_branch)]"; fi)\[\033[00m\]\$ '
# cyan for current directory
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[01;33m\]$(if [ -d .git ]; then echo " [$(parse_git_branch)]"; fi)\[\033[00m\]\$ '
# cyan for current directory, bright yellow for git branch
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[01;93m\]$(if [ -d .git ]; then echo " [$(parse_git_branch)]"; fi)\[\033[00m\]\$ '

alias ll="ls -la"
alias ls="ls --color=auto"
alias l.="ls -d .* --color=auto"
alias h="history"
alias ei="cd ~/.config/nvim; nvim"
alias so="source ~/.bashrc"
