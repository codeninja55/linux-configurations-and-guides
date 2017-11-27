# Arch Linux Installation on Dell XPS 13 9360

## System Configurations

```
CPU: Intel Core i7-7500U
Memory: 8GB LPDDR3 1866MHz
Hard Drive: 256GB PCIe SSD
Video Card: Intel Iris Graphics 640
Display: 13.3" QHD+ (3200x1800) InfinityEdge Touch Display
Network Card: Qualcomm Atheros QCA6174 802.11ac Wireless
```

## Please also consult official documentation on Arch wiki:

- <https://wiki.archlinux.org/index.php/Installation_Guide>
- <https://wiki.archlinux.org/index.php/Dell_XPS_13_(9360>)
- <https://wiki.archlinux.org/index.php/Dell_XPS_15_(9550>)

# Pre-Installation System Settings

- Press F2 when you see Dell logo to enter BIOS Settings
- Turn off legacy ROM
- System --> SATAT: change to AHCI
- Secure Boot: disable
- POST Behaviour: Fastboot: Thorough

# Pre-Installation Preparations

Download and create a bootable USB with [Arch Linux ISO](https://www.archlinux.org/download/)

## Boot from USB

- Plug in USB and power on device
- Press F12 when you see Dell logo to enter boot menu
- Select the USB

## Set Keyboard layout

To list available layouts: `ls /usr/share/kbd/keymaps/**/*.map.gz`

In our case, set the keymap to US (default): `loadkeys us`

## Set Font

To list available fonts: `ls /usr/share/kbd/consolefonts/*.gz`

Set a large font: `setfont latarcyrheb-sun32`

To see current fonts: `showconsolefont`

## Verify the boot mode

If UEFI is enabled (this Dell XPS 13 has UEFI), Archiso will boot ARch Linux accordingly via systemd-boot. To verify this, list the efivars director:

`ls /sys/firmware/efi/efivars`

IF the directory does not exist, the system may be booted in BIOS mode.

## Connect to Wifi and Internet

`wifi-menu`

Follow the onscreen prompts

### Test internet is working

`ping -c 3 google.com`

## Sync Clock

`timedatectl set-ntp true`

# Partitioning the Disks

Create two partitions:

- 512MB ESP ([EFI System Partition](https://wiki.archlinux.org/index.php/EFI_System_Partition))
- 100% Linux partition (with LVM and LUKS encryption)

To identify your disks: `lsblk` or `fdisk -l`

To use GUI (haha): `cgdisk /dev/nvme0n1`

```
[ New ]
<Enter> (Keep default)
512M (Size)
ef00 (Hex code for EFI System)
EFI (Name)

[ New ]
<Enter>
<Enter> (Full 100% size for root)
8300 (Hex code for Linux Filesystem)
/ (Name)

[ Write ]
[ Quit ]
```

To use Console: `fdisk /dev/nvme0n1`

Instructions: [fdisk Arch wiki](https://wiki.archlinux.org/index.php/Fdisk)

Format the ESP partition: `mkfs.fat -F32 /dev/nvme0n1p1`

## Setup [LUKS](https://wiki.archlinux.org/index.php/Disk_encryption) encryption for the System

Encrypt, confirm, and set net password: `cryptsetup luksFormat /dev/nvme0n1p2`

Unencrypt the new encrypted disk: `cryptsetup open /dev/nvme0n1p2 luks`

## Create [LVM](https://wiki.archlinux.org/index.php/LVM) Partitions

This creates partition for / only and no swap:

```
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate -l 100%FREE vg0 --name root
```

NOTE: to display created volumes use these commands:

Physical Volume: `pvdisplay`

Volume Groups: `vgdisplay`

Logical Volumes: `lvdisplay`

## Format the Partitions

`mkfs.ext4 /dev/mapper/vg0-root`

## Mount the new System

/mnt is the system to be installed

`mount /dev/mapper/vg0-root /mnt`

Make a boot directory and mount the EFI System

```
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

# Install Arch Linux Base

## Select the mirror to download packages from:

`nano /etc/pacman.d/mirrorlist`

Scroll down to the mirror you want then:

- Press < Alt > < 6 > to copy the line
- Scroll back up to the top of the list
- Press < Ctrl > < u > to paste that line
- Press < Ctrl > < o > to save file
- Press < Ctrl > < x > to exit

## Installing the base system plus a few packages

Check archlinux.org site to see packages installed with [base](https://www.archlinux.org/groups/x86_64/base/).

`pacstrap /mnt base vim git sudo efibootmgr wpa_supplicant dialog iw`

# Configure the System

## Generate fstab

`genfstab -L /mnt >> /mnt/etc/fstab`

## Verify and adjust fstab

Change relatime on all non-boot partitioners to noatime (reduces wear for SSD)

`nano /mnt/etc/fstab`

## Chroot

Change root into the new system: `arch-chroot /mnt`

## [Timezone](https://wiki.archlinux.org/index.php/Time#Time_zone)

To see a list of timezone regions: `ls /usr/share/zoneinfo/`

To see a list of timezone citiesL `ls /usr/share/zoneinfo/*region*/`

Create a symlink to the timezone:

```
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc
```

To see current time in software: `hwclock --show`

## Locale

Uncomment en_US.UTF-8 UTF-8 and en_AU.UTF-8 UTF 8 (English Australia) in /etc/locale/gen

`nano /etc/locale/gen`

Generate locale with: `locale-gen`

Set locale: `echo 'LANG=en_AU.UTF-8' > /etc/locale/conf`

Set the keyboard layout and font:

```
echo 'KEYMAP=us' > /etc/vconsole.conf
echo 'FONT=latarcyrheb-sun32' >> /etc/vconsole.conf
```

# [Hostname](https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname)

`echo '{hostname}' > /etc/hostname`

Consider adding a matching entry to hosts:

`echo '127.0.1.1 {hostname}.localdomain {hostname}' >> /etc/hosts`

# Network configuration

NOTE: Already installed required packages

The newly installed environment has no network connection activated per default. See Network configuration to configure one.

For Wireless configuration, install the iw and wpa_supplicant packages, as well as needed firmware packages. Optionally install dialog for usage of wifi-menu.

# Initramfs

Configure mkinitcpio with modules needed for the initrd image

`nano /etc/mkinitcpio.conf`

- /*NOT NECESSARY*/ Add: 'MODULES="ext4 dm_snapshot"'
- Change: `HOOKS="systemd autodetect modconf block keymap sd-encrypt sd-lvm2 filesystems keyboard"`
- NOTE DEFAULT: `HOOKS="base udev autodetect modconf block filesystems keyboard fsck"`

Regenerate initrd image:

`mkinitcpio -p linux`

# Root password

`passwd`

# Boot loader

Setup systemd-boot:

`bootctl --path=/boot install`

To install other bootloaders, go to [Category:Boot loaders](https://wiki.archlinux.org/index.php/Category:Boot_loaders)

Enable Intel microcode updates:

`pacman -S intel-ucode`

## Create bootloader entry:

Get luks-uuid: `cryptsetup luksUUID /dev/nvme0n1p2`

`nano /boot/loader/entries/arch.conf`

Copy these details:

```
---
title         Arch Linux
linux         /vmlinuz-linux
initrd        /intel-ucode.img
initrd        /initramfs-linux.img
options        luks.uuid={uuid} luks.name={uuid}=luks root=/dev/mapper/vg0-root rw
---
```

## Set default bootloader entry

`nano /boot/loader/loader.conf`

Copy these details:

```
---
default    arch
---
```

## Create Users


```
useradd -m -g users -G wheel -s /bin/bash {username}
passwd {username}
echo '{username} ALL=(ALL) ALL' > /etc/sudoers.d/{username}
```


## Finished

`exit`

`reboot`
