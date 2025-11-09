#!/bin/bash

# Read from,
APP_LIST_FILE="flatpak.txt"

# Check for "flatpak.txt"
if [[ ! -f "$APP_LIST_FILE" ]]; then
    echo "❌ Error: $APP_LIST_FILE not found!"
    echo "Please create a text file named '$APP_LIST_FILE' with one Flatpak ID per line."
    exit 1
fi

# Ensure Flathub remote exists
if ! flatpak remote-list | grep -q flathub; then
    echo " Adding Flathub... "
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo " Flathub remote exists "
fi

# Read and install each Flatpak
while IFS= read -r app || [[ -n "$app" ]]; do
    # Skip empty lines and comments
    [[ -z "$app" || "$app" =~ ^# ]] && continue

    echo " Installing $app... "
    
    # Check if the app is already installed
    if flatpak list --app | grep -q "$app"; then
        echo "   --> Already installed. Skipping... "
    else
        flatpak install -y flathub "$app"
    fi
done < "$APP_LIST_FILE"

echo " Done! "

