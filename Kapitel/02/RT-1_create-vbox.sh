#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "RT-1" --register
VBoxManage modifyvm RT-1 --memory 512
VBoxManage modifyvm RT-1 --description "VyOS Lab"
VBoxManage modifyvm RT-1 --ostype "Debian_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm RT-1 --nic1 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter1 "vboxnet1"
VBoxManage modifyvm RT-1 --nictype1 virtio
VBoxManage modifyvm RT-1 --macaddress1 0022b0010101

VBoxManage modifyvm RT-1 --nic2 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter2 "vboxnet6"
VBoxManage modifyvm RT-1 --nictype2 virtio
VBoxManage modifyvm RT-1 --macaddress2 0022b0010601

VBoxManage modifyvm RT-1 --nic3 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter3 "vboxnet4"
VBoxManage modifyvm RT-1 --nictype3 virtio
VBoxManage modifyvm RT-1 --macaddress3 0022b0010401

VBoxManage modifyvm RT-1 --nic4 bridged
VBoxManage modifyvm RT-1 --bridgeadapter4 eth1
VBoxManage modifyvm RT-1 --nictype4 virtio
VBoxManage modifyvm RT-1 --macaddress4 0022b0010011

VBoxManage modifyvm RT-1 --nic5 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter5 "vboxnet7"
VBoxManage modifyvm RT-1 --nictype5 virtio
VBoxManage modifyvm RT-1 --macaddress5 0022b0010701


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl RT-1 --name "IDE Controller" --add ide
VBoxManage storageattach RT-1 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/vyos-1.1.7-amd64.iso

# Festplatte
VBoxManage storagectl RT-1 --name "SATA Controller" --add sata
VBoxManage createhd --filename "RT-1/RT-1.vdi" --size 2048 --format VDI --variant Fixed
VBoxManage storageattach RT-1 --storagectl "SATA Controller" --medium "RT-1/RT-1.vdi" --port 0 --type hdd


# Serielle Konsole
VBoxManage modifyvm RT-1 --uart1 0x3F8 4
VBoxManage modifyvm RT-1 --uartmode1 server /tmp/RT-1.pipe

# RDP-Konsole
VBoxManage modifyvm RT-1 --vrde on
VBoxManage modifyvm RT-1 --vrdeport 8001
