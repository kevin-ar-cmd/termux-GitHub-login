#!/bin/bash

# Display the current directory
echo "Current Directory: $(pwd)"

# Show all files and folders
echo "Files and Folders:"
ls -lah

# Get the Termux username (if available)
USER_NAME=$(whoami)
echo "Termux Username: $USER_NAME"

# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing Git..."
    pkg update && pkg install git -y
fi

# Configure Git with your username and email
read -p "Enter your GitHub username: " GH_USER
read -p "Enter your GitHub email: " GH_EMAIL

git config --global user.name "$GH_USER"
git config --global user.email "$GH_EMAIL"

# Check if SSH key exists, if not generate one
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$GH_EMAIL"
    echo "Copy the following SSH key and add it to your GitHub account:"
    cat ~/.ssh/id_rsa.pub
    echo "Go to https://github.com/settings/keys and add the SSH key."
fi

# Test GitHub authentication
echo "Testing GitHub connection..."
ssh -T git@github.com

# Show configured GitHub username
echo "Your configured GitHub username: $(git config --global user.name)"
