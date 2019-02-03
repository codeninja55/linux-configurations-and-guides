# Ubuntu 18.04 with G.E.N.I.E Intel i9 9900K PC

## System Configurations:

```
CPU: Intel Core i9 9900K
Motherboard: Asus ROG Maximus XI Extreme (BIOS 0602)
Memory: 32GB DIMM DDR4 3200MHZ
Hard Drive: 521GB V-NAND SSD with NVMe M.2 connectors
Onboard GPU: Intel UHD Graphics support
Additional GPU: 2x Asus GeForce RTX 2080 Ti Dual
```

## Ubuntu and Linux Configurations:

```
Linux Kernel: 4.20.0-042000-generic
OS Version: Ubuntu 18.04.1 LTS Bionic
GPU Driver: nvidia-driver-415.25
CUDA Version: CUDA 10.0
```

## Pre-Installation System Settings

- Press F2 when you see Republic of Gamers logo to enter BIOS Settings
- System --> SATA: change to AHCI
- Secure Boot: disable
- Fast Boot: disable

## Pre-Installation Preparations

Download from [here](http://releases.ubuntu.com/18.04/) or directly from [ubuntu-18.04.1-desktop-amd64.iso](http://releases.ubuntu.com/18.04/ubuntu-18.04.1-desktop-amd64.iso) and create a bootable USB with [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/)

## Boot from USB

- Plug in USB and power on device
- Press F8 when you see Republic of Gamers logo to enter boot menu
- Select the USB

## Install Ubuntu 18.04

- Follow the installation GUI
- Select 'Erase Disk and Install Ubuntu' on nvme0n1
  - Also select 'LVM' and 'Encryption'
- Complete rest of installation