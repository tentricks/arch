#!/bin/bash

notify-send "System Update" "Updating packages..."

sudo ~/.config/script/update-all.sh

notify-send "System Update" "Update complete"