#!/bin/bash

# Sync + upgrade system + AUR silently
sudo pacman -Syu --noconfirm
yay -Syu --noconfirm

# Clean up orphans
ORPHANS=$(pacman -Qdtq)
if [ -n "$ORPHANS" ]; then
  sudo pacman -Rns --noconfirm $ORPHANS
fi

# Clean package cache (keeping 3 versions)
sudo paccache -r
