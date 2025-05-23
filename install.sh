#!/bin/bash
# chroot-install.sh - Run inside chroot (/mnt)

echo "Installing Arch Linux"

set -e

# Prompt for hostname
read -rp "Enter hostname: " HOSTNAME

echo "$HOSTNAME" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1       localhost
::1             localhost
127.0.1.1       $HOSTNAME.localdomain $HOSTNAME
EOF

# Timezone, locale
ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
hwclock --systohc

sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Prompt for user and password
read -rp "Enter new username: " USERNAME
useradd -mG wheel "$USERNAME"
passwd "$USERNAME"

# Sudo
sed -i 's/^# %wheel/%wheel/' /etc/sudoers

# Install packages
pacman -Syu --noconfirm
pacman -S --noconfirm hyprland wayland xdg-desktop-portal-hyprland wl-clipboard kitty \
    pacman-contrib rsync sddm ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
    waybar mako libnotify rofi

# Enable services
systemctl enable NetworkManager
systemctl enable sddm

# Setup GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Set up configs and scripts
sudo -u "$USERNAME" git clone https://github.com/tentricks/arch.git /home/$USERNAME/temp-arch
rsync -a /home/$USERNAME/temp-arch/dotfiles/.config/ /home/$USERNAME/.config/
rsync -a /home/$USERNAME/temp-arch/scripts/ /home/$USERNAME/.config/scripts/
chown -R "$USERNAME:$USERNAME" /home/$USERNAME/.config
rm -rf /home/$USERNAME/temp-arch

# Add autostarts to Hyprland config
HCONF="/home/$USERNAME/.config/hypr/hyprland.conf"
grep -q 'exec-once = waybar' "$HCONF" || echo 'exec-once = waybar' >> "$HCONF"
grep -q 'exec-once = mako' "$HCONF" || echo 'exec-once = mako' >> "$HCONF"

# Done
echo "\nSetup complete. You can now exit chroot, unmount, and reboot."
