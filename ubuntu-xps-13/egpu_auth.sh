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
lspci -nn | grep -E 'VGA|Display|3D'
echo ""
echo "Check if Ubuntu recognises drivers..."
ubuntu-drivers devices
echo ""
