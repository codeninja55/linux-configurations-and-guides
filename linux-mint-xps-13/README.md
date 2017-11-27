# Linux Mint Installation on Dell XPS 13 9360
## System Configurations:
```
CPU: Intel Core i7-7500U
Memory: 8GB LPDDR3 1866MHz
Hard Drive: 256GB PCIe SSD
Video Card: Intel Iris Graphics 640
Display: 13.3" QHD+ (3200x1800) InfinityEdge Touch Display
Network Card: Qualcomm Atheros QCA6174 802.11ac Wireless
```

## Pre-Installation System Settings

* Press F2 when you see Dell logo to enter BIOS Settings
* Turn off legacy ROM
* System --> SATAT: change to AHCI
* Secure Boot: disable
* POST Behaviour: Fastboot: Thorough

## Pre-Installation Preparations

Download and create a bootable USB with [Linux Mint ISO](https://www.linuxmint.com/download.php)

## Boot from USB

* Plug in USB and power on device
* Press F12 when you see Dell logo to enter boot menu
* Select the USB
* Open terminal with < Ctrl > + < Alt > + < t >

Increase scaling interface for HiDPI screen: `$ gsettings set org.cinnamon.desktop.interface scaling-factor 2`

## Install Linux Mint
* Follow the installation GUI
* Select 'Erase Disk and Install Linux Mint' **(WARNING: this is not for a dual booting setup)**
  * Also select 'LVM' and 'Encryption'
* Complete rest of installation

## Reducing Size of swap
Consult these documentations for more information:
* [An Introduction to LVM Concepts, Terminology, and Operations](https://www.digitalocean.com/community/tutorials/an-introduction-to-lvm-concepts-terminology-and-operations#)
* [ResizeEncryptedPartitions Ubuntu Documentations](https://help.ubuntu.com/community/ResizeEncryptedPartitions)
* [How To Use LVM To Manage Storage Devices on Ubuntu 16.04 - Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-use-lvm-to-manage-storage-devices-on-ubuntu-16-04)

Continue with:
* Keep Linux Mint Live USB plugged in
* Reboot into Live USB
* Open up a terminal

Install packages if required: `$ sudo apt-get update && sudo apt-get install lvm2 cryptsetup`

Load the cryptsetup module: `$ sudo modprobe dm-crypt`

Decrypt the file system: `$ sudo cryptsetup luksOpen /dev/nvme0n1p3 crypt1`

Get the live USB to recognise and activate the LVM:
```
$ sudo vgscan --mknodes
$ sudo vgchange -ay
```

Check to see the FS is intact: `$ sudo e2fsck -f /dev/mint-vg/root`

##### Some Useful commands

**To scan:**

Physical Volumes: `$ sudo pvscan`

Volume Groups: `$ sudo vgscan`

Logical Volumes: `$ sudo lvscan`

**To display current LVM mappings:**

Physical Volumes: `$ sudo pvdisplay` or `$ sudo pvs`

Volume Groups: `$ sudo vgdisplay` or `$ sudo vgs`

Logical Volumes: `$ sudo lvdisplay` or `$ sudo lvs`

### Resizing your root LV and removing Swap LV

Remove the swap Logical Volume first: `$ sudo lvremove /dev/mint-vg/swap_1`

Unlock the LVM Physical Volume: `$ sudo pvchange -x y /dev/mapper/crypt1`

Resize the crypt: `$ sudo cryptsetup resize crypt1`

Resize the LVM PV: `$ sudo pvresize /dev/mapper/crypt1`

Resize the size of root by 3.89 GB: `$ sudo lvresize -L +3.89G /dev/mint-vg/root`

Resize the filesystem:
```
$ sudo e2fsck -f /dev/mint-vg/root
$ sudo resize2fs -p /dev/mint-vg/root
```

### Restoring your Swap LV and Updating /etc/fstab

Check there are no errors on root LV: `$ sudo e2fsck -f /dev/mapper/mint-vg/root`

Restore swap LV:
```
$ sudo lvcreate -L 4G -n swap_1 mint-vg
$ sudo mkswap -L swap_1 /dev/mint-vg/swap_1
```
* As the mkswap command finishes it will print the new UUID to the terminal.
* Note this down.

Re-lock the Physical Volume: `$ sudo pvchange -x n /dev/mapper/nvme0n1`

##### Updating fstab in the root filesystem
**NOT NECESSARY**

Mount the root LV: `$ sudo mount /dev/mint-vg/root /mnt`

Edit the fstab: `$ nano /mnt/etc/fstab`
* Copy the UUID from the terminal or wherever you wrote it down.
* This goes in place where the swap UUID is already there

Unmount: `$ sudo umount /mnt`
