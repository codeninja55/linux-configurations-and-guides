# Parrot OS Installation on Dell XPS 13 9360
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

## Install Parrot OS
* Follow the installation GUI
* Select 'Erase Disk and Install Parrot OS' **(WARNING: this is not for a dual booting setup)**
  * Also select 'LVM' and 'Encryption'
* Complete rest of installation
