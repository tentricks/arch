#!/bin/bash

# Define source paths
REPO_DIR="$(git rev-parse --show-toplevel)"
DOTFILES_DIR="$REPO_DIR/dotfiles/.config"
SCRIPTS_DIR="$REPO_DIR/scripts"

# Define destination paths
DEST_CONFIG=~/.config
DEST_SCRIPTS="$DEST_CONFIG/scripts"

echo "Syncing configs..."

# Copy waybar and hypr configs
cp -r "$DOTFILES_DIR/waybar" "$DEST_CONFIG/"
cp -r "$DOTFILES_DIR/hypr" "$DEST_CONFIG/"
cp -r "$DOTFILES_DIR/mako" "$DEST_CONFIG/"

echo "Waybar and Hyprland configs copied."

# Ensure scripts directory exists
mkdir -p "$DEST_SCRIPTS"

# Copy and make scripts executable
cp "$SCRIPTS_DIR"/*.sh "$DEST_SCRIPTS/"
chmod +x "$DEST_SCRIPTS"/*.sh

echo "Scripts copied and made executable."

# Reload Waybar and Hyprland config
echo "Reloading Waybar and Hyprland..."
pkill waybar && waybar &>/dev/null &

# Optionally reload Hyprland config
hyprctl reload

echo "Dotfiles deployed and live!"
