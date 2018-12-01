#!/bin/bash

echo "Check that kernel version is at least 4.13"
uname -a
echo ""
echo "Check that eGPU appears as Thunderbolt device"
cat /sys/bus/thunderbolt/devices/0-1/device_name 
echo ""
echo "Authorize eGPU device"
sudo sh -c 'echo 1 > /sys/bus/thunderbolt/devices/0-1/authorized'
echo ""
echo "Check that eGPU now shows up with lspci"
lspci -vnn | grep VGA
echo ""
echo "Check that Nvidia shows up with lshw"
sudo lshw -C display
echo ""
hwinfo --gfxcard
echo ""
glxinfo | grep "OpenGL"
echo ""
ubuntu-drivers devices
