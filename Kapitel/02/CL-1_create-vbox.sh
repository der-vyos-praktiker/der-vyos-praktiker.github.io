#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "cl-1" --register
VBoxManage modifyvm cl-1 --memory 512
VBoxManage modifyvm cl-1 --description "VyOS Lab"
VBoxManage modifyvm cl-1 --ostype "Debian_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm cl-1 --nic1 bridged
VBoxManage modifyvm cl-1 --bridgeadapter1 eth1.1401
VBoxManage modifyvm cl-1 --nictype1 virtio
VBoxManage modifyvm cl-1 --macaddress1 0022b0110125


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl cl-1 --name "IDE Controller" --add ide
VBoxManage storageattach cl-1 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/debian-8.6.0-amd64-DVD-1.iso

# Festplatte
VBoxManage storagectl cl-1 --name "SATA Controller" --add sata
VBoxManage createhd --filename "cl-1/cl-1.vdi" --size 10240 --format VDI --variant Fixed
VBoxManage storageattach cl-1 --storagectl "SATA Controller" --medium "cl-1/cl-1.vdi" --port 0 --type hdd


# RDP-Konsole
VBoxManage modifyvm cl-1 --vrde on
VBoxManage modifyvm cl-1 --vrdeport 8011
