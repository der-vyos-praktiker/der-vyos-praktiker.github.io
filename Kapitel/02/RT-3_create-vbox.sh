#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "RT-3" --register
VBoxManage modifyvm RT-3 --memory 512
VBoxManage modifyvm RT-3 --description "VyOS Lab"
VBoxManage modifyvm RT-3 --ostype "Debian_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm RT-3 --nic1 hostonly
VBoxManage modifyvm RT-3 --hostonlyadapter1 "vboxnet2"
VBoxManage modifyvm RT-3 --nictype1 virtio
VBoxManage modifyvm RT-3 --macaddress1 0022b0030203

VBoxManage modifyvm RT-3 --nic2 hostonly
VBoxManage modifyvm RT-3 --hostonlyadapter2 "vboxnet6"
VBoxManage modifyvm RT-3 --nictype2 virtio
VBoxManage modifyvm RT-3 --macaddress2 0022b0030603

VBoxManage modifyvm RT-3 --nic3 bridged
VBoxManage modifyvm RT-3 --bridgeadapter3 eth1
VBoxManage modifyvm RT-3 --nictype3 virtio
VBoxManage modifyvm RT-3 --macaddress3 0022b0030013


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl RT-3 --name "IDE Controller" --add ide
VBoxManage storageattach RT-3 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/vyos-1.1.7-amd64.iso

# Festplatte
VBoxManage storagectl RT-3 --name "SATA Controller" --add sata
VBoxManage createhd --filename "RT-3/RT-3.vdi" --size 2048 --format VDI --variant Fixed
VBoxManage storageattach RT-3 --storagectl "SATA Controller" --medium "RT-3/RT-3.vdi" --port 0 --type hdd


# Serielle Konsole
VBoxManage modifyvm RT-3 --uart1 0x3F8 4
VBoxManage modifyvm RT-3 --uartmode1 server /tmp/RT-3.pipe

# RDP-Konsole
VBoxManage modifyvm RT-3 --vrde on
VBoxManage modifyvm RT-3 --vrdeport 8003
