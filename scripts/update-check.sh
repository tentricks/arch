#!/bin/bash

UPDATES=$(checkupdates 2>/dev/null | wc -l)
AUR=$(yay -Qua 2>/dev/null | wc -l)

TOTAL=$((UPDATES + AUR))

if [ "$TOTAL" -eq 0 ]; then
  echo "{\"text\": \"\", \"tooltip\": \"System is up to date.\"}"
else
  echo "{\"text\": \"󱇮\", \"tooltip\": \"$TOTAL updates available.\"}"
fi
