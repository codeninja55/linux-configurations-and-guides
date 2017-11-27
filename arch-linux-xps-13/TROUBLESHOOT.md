
# Troubleshooting Guide

## Booting from Live USB
Plug the Live USB in again.

Press F12 when you see the Dell logo.

Set a large font: `setfont latarcyrheb-sun32`

Connect to Wifi and internet: `wifi-menu`

Test internet is working: `ping -c 3 google.com`

Unencrypt the encrypted disk and mount:
```
cryptsetup open /dev/nvme0n1p2 luks
mount /dev/mapper/vg0-root /mnt
mount /dev/nvme0n1p1 /mnt/boot
```

Change root into the new system: `arch-chroot /mnt`

## Fixing Wireless Card Drivers


FOR QUALCOMM ATHEROS QCA6174, required to run:
chmod +x /lib/firmware/ath10k/QCA6174/hw3.0/*
