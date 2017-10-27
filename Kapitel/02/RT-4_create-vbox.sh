#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "RT-4" --register
VBoxManage modifyvm RT-4 --memory 512
VBoxManage modifyvm RT-4 --description "VyOS Lab"
VBoxManage modifyvm RT-4 --ostype "Debian_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm RT-4 --nic1 hostonly
VBoxManage modifyvm RT-4 --hostonlyadapter1 "vboxnet2"
VBoxManage modifyvm RT-4 --nictype1 virtio
VBoxManage modifyvm RT-4 --macaddress1 0022b0040204

VBoxManage modifyvm RT-4 --nic2 hostonly
VBoxManage modifyvm RT-4 --hostonlyadapter2 "vboxnet7"
VBoxManage modifyvm RT-4 --nictype2 virtio
VBoxManage modifyvm RT-4 --macaddress2 0022b0040604

VBoxManage modifyvm RT-4 --nic3 bridged
VBoxManage modifyvm RT-4 --bridgeadapter3 eth1
VBoxManage modifyvm RT-4 --nictype3 virtio
VBoxManage modifyvm RT-4 --macaddress3 0022b0040014


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl RT-4 --name "IDE Controller" --add ide
VBoxManage storageattach RT-4 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/vyos-1.2.0-beta1-amd64.iso

# Festplatte
VBoxManage storagectl RT-4 --name "SATA Controller" --add sata
VBoxManage createhd --filename "RT-4/RT-4.vdi" --size 2048 --format VDI --variant Fixed
VBoxManage storageattach RT-4 --storagectl "SATA Controller" --medium "RT-4/RT-4.vdi" --port 0 --type hdd


# Serielle Konsole
VBoxManage modifyvm RT-4 --uart1 0x3F8 4
VBoxManage modifyvm RT-4 --uartmode1 server /tmp/RT-4.pipe

# RDP-Konsole
VBoxManage modifyvm RT-4 --vrde on
VBoxManage modifyvm RT-4 --vrdeport 8004
