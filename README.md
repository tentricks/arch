# 🐧 Arch Linux Installation Journal
> Mostly a reference for future me for when I decide to do this again
---

## Installation

### 1. Boot from Arch ISO (via Ventoy)

- Use [Ventoy](https://www.ventoy.net/en/download.html) to boot the latest Arch ISO from USB since this tool allows for numerous ISOs in a single thumbdrive

---

### 2. Connect to Wi-Fi

```
iwctl
# Inside iwctl shell:
device list
station wlan0 connect YOUR_SSID
exit
```

---

### 3. Partitioning (UEFI + swapless)

Used `cfdisk` on `/dev/sda`:

- 512MiB EFI System Partition (type: EFI)
- Remaining space: Linux filesystem (for `/`)

---

### 4. Format Partitions

```
mkfs.fat -F32 /dev/sda1      # EFI
mkfs.ext4 /dev/sda2          # Root
```

---

### 5. Mount and Install Base System

```
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

pacstrap -K /mnt base linux linux-firmware nano networkmanager grub efibootmgr
```

---

### 6. System Configuration

```
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
hwclock --systohc

nano /etc/locale.gen   # uncomment en_US.UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "archpc" > /etc/hostname
nano /etc/hosts        # added localhost lines

passwd                 # set root password

useradd -mG wheel erik
passwd erik
EDITOR=nano visudo     # uncomment '%wheel ALL=(ALL:ALL) ALL'
```

---

### 7. Install and Configure GRUB (UEFI)

```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

---

### 8. Enable Network and Reboot

```
systemctl enable NetworkManager
exit
umount -R /mnt
reboot
```

---

## First Boot & Hyprland

### 9. Logged in as user, updated system

```
sudo pacman -Syu
```

---

### 10. Installed minimal Hyprland setup

```
sudo pacman -S hyprland wayland xdg-desktop-portal-hyprland wl-clipboard networkmanager kitty
```

---

### 11. Created config manually

```
mkdir -p ~/.config/hypr
nano ~/.config/hypr/hyprland.conf
# → added minimal config with kitty as default terminal
```

---

### 12. Launched Hyprland from console

```
Hyprland
```

Success! Tiling worked, terminal popped up, it lived 🎉

---

## 🧙‍♂️ Post-Install

### Installed a login manager

``` bash
sudo pacman -S sddm
sudo systemctl enable sddm
```

- Make sure that `/usr/share/wayland-sessions/Hyprland.desktop` exists

To create it:
``` base
sudo nano /usr/share/wayland-sessions/hyprland.deskop
```
Paste:
```ini
[Desktop Entry]
Name=Hyprland
Comment=Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
```

### Install an app launcher

### Install a notification daemon

### Install bars (menu and status panel)

### Install a lock screen

### Install audio system

### Install clipboard manager

### Install file manager

### Install browser

### Install polkit agent

### Install terminal fetch

---

## Utilities

### Managing installed packages

* See everything installed via pacman
```
pacman -Qe
```

* See everything installed via yay
```
yay -Qm
```

* See dependencies that are no longer required
```
pacman -Qdt
```

* Remove such dependencies:
```
sudo pacman -Rns $(pacman -Qdtq) --print
```

* Save a list of installed packages
```
pacman -Qqe > pkglist.txt
yay -Qm > aurlist.txt
```

* Reinstall via list
```
sudo pacman -S --needed - < pkglist.txt
yay -S --needed < aurlist.txt
```

* Show package details
```
pacman -Qi PACKAGE_NAME #show details
pactree -r PACKAGE_NAME #show dependencies
pactree -d1 PACKAGE_NAME #show dependents
```
pacman -Qi PACKAGE_NAME
```

* List packages and their size
```
pacman -Qi | awk '/^Name/{n=$3}/^Installed Size/{print $4, $5, n}' | sort -hr
```
