# Ubuntu Gnome 17.10 Installation on Microsoft Surface Book with Performance Base (2017)
## System Configurations:
```
CPU: Intel Core i7-6600U
Memory: 16GB
Hard Drive: Toshiba THNSN5512GPU7 256GB PCIe SSD
Video Card: Intel HD Graphics 520 and NVIDIA GeForce® GTX 965M 2GB GPU
Display: 13.5” PixelSense™ Display
Resolution: 3000 x 2000 (267 PPI)
Network Card: Marvell AVASTAR Wireless-AC Network Controller
Security: TPM 2.0 chip
```

## Pre-Installation System Settings

_N/A_. 

Installation on VMWare Workstation Pro 14



## Pre-Installation Preparations

Download and create a bootable USB with [Ubuntu Gnome](https://ubuntugnome.org/download/)

## Boot from USB

_N/A_



## Install Ubuntu 17.04
* VMWare Workstation Pro 14 includes __Ubuntu Easy Install__.

  ​

## Virtual Machine Configurations



1. Select `Custom (advanced)`
2. Select __Hardware compatibility:__ `Workstation 14.x`
3. Select __Installer disc image file (iso):__ and find the downloaded ISO for Ubuntu in your host device.
4. Fill in the details for __Personalize Linux__ to enable __VMWare Easy Install__ 
5. Input __Virtual machine name:__
6. Select a directory to save all files by selection `Browse`
7. Then follow the following Hardware configurations:

| Option                | Selection                                | Comments                                 |
| --------------------- | ---------------------------------------- | ---------------------------------------- |
| __Processors__        | 2 processors and 2 cores per processor.  |                                          |
| __Memory__            | 4096 MB (4GB) or 8192 MB (8GB)           |                                          |
| __Network Type__      | Network Address Translation or Bridged   | Use NAT during installation for simplicity and change to bridged if required later. |
| __SCSI Controller__   | LSI Logic                                |                                          |
| __Virtual Disk Type__ | SCSI or NVMe                             |                                          |
| __Disk__              | 60.0 GB maximum disc space. Also select _allocate all disk space now_ and _store virtual disk as a single file_. |                                          |
| __Disk file__         | Leave as default to save into Virtual Machine directory chosen earlier. |                                          |
| __USB Controller__    | _USB3.0 compatibility_ and all other options selected. |                                          |
| __Display__           | Select _accelerate 3D graphics_ and 1 GB for _graphics memory_. |                                          |



_NOTES:_

* Go to `Options` and select `Shared folders`.
  * Add shared folders as required.
* Open-VM-Tools is installed by default with Ubuntu 17.10.