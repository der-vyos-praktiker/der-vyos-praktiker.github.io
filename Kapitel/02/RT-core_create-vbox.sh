#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "RT-core" --register
VBoxManage modifyvm RT-core --memory 512
VBoxManage modifyvm RT-core --description "VyOS Lab"
VBoxManage modifyvm RT-core --ostype "Debian_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm RT-core --nic1 bridged
VBoxManage modifyvm RT-core --bridgeadapter1 eth1
VBoxManage modifyvm RT-core --nictype1 virtio
VBoxManage modifyvm RT-core --macaddress1 0022b0060021

VBoxManage modifyvm RT-core --nic2 hostonly
VBoxManage modifyvm RT-core --hostonlyadapter2 "vboxnet6"
VBoxManage modifyvm RT-core --nictype2 virtio
VBoxManage modifyvm RT-core --macaddress2 0022b0060606

VBoxManage modifyvm RT-core --nic3 hostonly
VBoxManage modifyvm RT-core --hostonlyadapter3 "vboxnet7"
VBoxManage modifyvm RT-core --nictype3 virtio
VBoxManage modifyvm RT-core --macaddress3 0022b0060706


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl RT-core --name "IDE Controller" --add ide
VBoxManage storageattach RT-core --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/vyos-1.2.0-beta1-amd64.iso

# Festplatte
VBoxManage storagectl RT-core --name "SATA Controller" --add sata
VBoxManage createhd --filename "RT-core/RT-core.vdi" --size 2048 --format VDI --variant Fixed
VBoxManage storageattach RT-core --storagectl "SATA Controller" --medium "RT-core/RT-core.vdi" --port 0 --type hdd


# Serielle Konsole
VBoxManage modifyvm RT-core --uart1 0x3F8 4
VBoxManage modifyvm RT-core --uartmode1 server /tmp/RT-core.pipe

# RDP-Konsole
VBoxManage modifyvm RT-core --vrde on
VBoxManage modifyvm RT-core --vrdeport 8006
