#!/bin/bash

# Check if a filename was provided
if [ -z "$1" ]; then
  echo "Usage: $0 filename"
  exit 1
fi

# Get the filename from the first argument
FILENAME="$1"

# Execute chezmoi commands
chezmoi add "$FILENAME"
chezmoi -v apply

# Change to the chezmoi managed directory without using a subshell
chezmoi_dir=$(chezmoi source-path)
cd "$chezmoi_dir" || exit

# Execute git commands
git add .
git commit -m "update $FILENAME"
git push origin main

