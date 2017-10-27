#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "cl-3" --register
VBoxManage modifyvm cl-3 --memory 1024
VBoxManage modifyvm cl-3 --description "VyOS Lab"
VBoxManage modifyvm cl-3 --ostype "Windows 7 (64-bit)"

# Netzwerkkarten einrichten
VBoxManage modifyvm cl-3 --nic1 bridged
VBoxManage modifyvm cl-3 --bridgeadapter1 eth1.1403
VBoxManage modifyvm cl-3 --nictype1 virtio
VBoxManage modifyvm cl-3 --macaddress1 0022b0130325


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl cl-3 --name "IDE Controller" --add ide
VBoxManage storageattach cl-3 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/win7.iso

# Festplatte
VBoxManage storagectl cl-3 --name "SATA Controller" --add sata
VBoxManage createhd --filename "cl-3/cl-3.vdi" --size 10240 --format VDI --variant Fixed
VBoxManage storageattach cl-3 --storagectl "SATA Controller" --medium "cl-3/cl-3.vdi" --port 0 --type hdd


# RDP-Konsole
VBoxManage modifyvm cl-3 --vrde on
VBoxManage modifyvm cl-3 --vrdeport 8013
