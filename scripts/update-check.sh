#!/bin/bash

UPDATES=$(checkupdates 2>/dev/null | wc -l)
AUR=$(yay -Qua 2>/dev/null | wc -l)

TOTAL=$((UPDATES + AUR))

if [ "$TOTAL" -eq 0 ]; then
  echo " 0"
else
  echo " $TOTAL"
fi
