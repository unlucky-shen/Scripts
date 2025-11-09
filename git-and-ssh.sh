#!/bin/bash

set -e

echo "
##############################
### Git + SSH Setup Script ###
##############################
"

# Input username and email
read -rp "Enter your Git username: " GIT_USERNAME
read -rp "Enter your Git email: " GIT_EMAIL

echo
echo " Configuring Git... "
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

# Generate SSH key
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ -f "$SSH_KEY" ]; then
    echo
    echo " SSH key already exists at $SSH_KEY "
else
    echo
    echo " Generating a new SSH key... "
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
fi

# Start ssh-agent
echo
echo " Starting ssh-agent... "
eval "$(ssh-agent -s)"

# Add SSH key to agent
echo
echo " Adding SSH key to ssh-agent... "
ssh-add "$SSH_KEY"

# Public key
echo
echo " Public Key: "
echo "################################################################"
cat "${SSH_KEY}.pub"
echo "################################################################"

echo
echo "Setup complete!"
