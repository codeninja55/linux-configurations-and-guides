# Ubuntu 18.04 with CN55 G.E.N.I.E Intel i9 9900K PC

## System Configurations:

```
CPU: Intel Core i9 9900K
Memory: 32GB 
Hard Drive: 256GB PCIe SSD
Onboard GPU: Intel Iris Graphics 640
Internal GPU: 2x Asus GeForce RTX 2080 Ti Dual
Network Card: 
```

## Pre-Installation System Settings

- Press F2 when you see Dell logo to enter BIOS Settings
- Turn off legacy ROM
- System --> SATAT: change to AHCI
- Secure Boot: disable
- POST Behaviour: Fastboot: Thorough

## Pre-Installation Preparations

Download and create a bootable USB with [Ubuntu Gnome](https://ubuntugnome.org/download/)

## Boot from USB

- Plug in USB and power on device
- Press F12 when you see Dell logo to enter boot menu
- Select the USB
- Open terminal with < Ctrl > + < Alt > + < t >

## Install Ubuntu 18.04

- Follow the installation GUI
- Select 'Erase Disk and Install Linux Mint' **(WARNING: this is not for a dual booting setup)**
  - Also select 'LVM' and 'Encryption'
- Complete rest of installation