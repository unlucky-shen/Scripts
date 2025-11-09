#!/bin/bash

set -e

# Remove Listed Packages
PACKAGES=(
  epiphany
  gnome-contacts
  gnome-calculator
  gnome-calendar
  gnome-weather
  gnome-text-editor
  malcontent
  nano
  vim
)

echo "The following packages will be removed:"
for pkg in "${PACKAGES[@]}"; do
  echo "  - $pkg"
done

read -rp "Proceed with removal? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  # Remove packages with pacman
  sudo pacman -Rns --noconfirm "${PACKAGES[@]}"
  echo "Packages removed successfully."
else
  echo "Operation cancelled."
fi

# Install Packages.
PACKAGES=(
	# Core Utils.
	wget
	curl
	flatpak
	neovim
	htop
	openssh
	# Essentials Apps.
	kitty
	tmux
	zathura
	zathura-pdf-poppler
	# Dev Tools.
	gcc
	python
	python-pip
	nodejs
	npm 
	rustup
	go
	texlive-meta
	r
	# Misc.
	mesa-demos
	glxinfo
	glxgears
	# NVIDIA Support
	nvidia-prime
	vulkan-icd-loader
	# Intel support
	mesa 
	vulkan-intel
)

echo "==> Updating system..."
sudo pacman -Syu --noconfirm

echo "==> Installing packages..."
for pkg in "${PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "$pkg is already installed"
  else
    echo "➜ Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg"
  fi
done

# Yay
echo "==> Setting up yay (AUR helper)..."

if command -v yay &>/dev/null; then
  echo "yay is already installed."
else
  echo "Installing yay from AUR..."
  sudo pacman -S --needed --noconfirm git base-devel
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir"
  cd "$tmpdir"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
fi

echo "==> Essential packages and yay installed!"
