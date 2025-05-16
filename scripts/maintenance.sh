#!/bin/bash

# Timestamp
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
LOGDIR="$HOME/.logs/arch-maint"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/maint-$NOW.log"

echo "Updating system... ($(date))" | tee -a "$LOGFILE"

# Update pacman packages
sudo pacman -Syu --noconfirm | tee -a "$LOGFILE"

# Clean orphaned packages
echo "Cleaning orphaned packages..." | tee -a "$LOGFILE"
ORPHANS=$(pacman -Qdtq)
if [ -n "$ORPHANS" ]; then
  sudo pacman -Rns --noconfirm $ORPHANS | tee -a "$LOGFILE"
else
  echo "No orphaned packages found." | tee -a "$LOGFILE"
fi

# Update AUR packages (with yay)
if command -v yay &> /dev/null; then
  echo "Updating AUR packages..." | tee -a "$LOGFILE"
  yay -Syu --noconfirm | tee -a "$LOGFILE"
else
  echo "yay not found, skipping AUR updates." | tee -a "$LOGFILE"
fi

# 🧾 Save package lists
echo "Saving package lists..." | tee -a "$LOGFILE"
mkdir -p "$HOME/.pkgbackup"
pacman -Qqe > "$HOME/.pkgbackup/pkglist-$NOW.txt"
yay -Qm > "$HOME/.pkgbackup/aurlist-$NOW.txt"

# Show top 10 biggest installed packages
echo -e "\nTop 10 largest installed packages:" | tee -a "$LOGFILE"
pacman -Qi | awk '/^Name/{n=$3}/^Installed Size/{print $4, $5, n}' | sort -hr | head -n 10 | tee -a "$LOGFILE"

echo -e "\nDone! Log saved to: $LOGFILE"
