#!/bin/bash

# Ask the user for a custom username
read -p "Enter your preferred Termux username: " custom_username

# Check if the input is empty
if [ -z "$custom_username" ]; then
    echo "Username cannot be empty! Please run the script again."
    exit 1
fi

# Define the ~/.bashrc file path
BASHRC_FILE="$HOME/.bashrc"

# Create .bashrc file if it doesn't exist
if [ ! -f "$BASHRC_FILE" ]; then
    touch "$BASHRC_FILE"
fi

# Backup existing .bashrc file
cp "$BASHRC_FILE" "$BASHRC_FILE.bak"

# Write new .bashrc content
cat > "$BASHRC_FILE" <<EOF
# Add Gradle to PATH
export PATH=\$PATH:/data/data/com.termux/files/usr/share/gradle

# Android SDK Paths
export ANDROID_HOME=\$HOME/android-sdk
export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools

# Set custom Termux username
export USER="$custom_username"

# Custom Prompt (with colors)
export PS1="\\e[1;32m$custom_username@termux:\\e[1;34m\\w\\e[0m\$ "

# Start SSH-Agent and add SSH key
eval \$(ssh-agent -s)
EOF

# Check if SSH key exists, if not generate one
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$custom_username@termux"
    echo "Copy the following SSH key and add it to your GitHub account:"
    cat ~/.ssh/id_rsa.pub
    echo "Go to https://github.com/settings/keys and add the SSH key."
fi

# Add SSH key to the agent
ssh-add ~/.ssh/id_rsa

# Apply changes
source "$BASHRC_FILE"

# Confirm changes
echo "Username changed successfully! Your new Termux prompt is:"
echo "$custom_username@termux:~$"
