#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "RT-2" --register
VBoxManage modifyvm RT-2 --memory 512
VBoxManage modifyvm RT-2 --description "VyOS Lab"
VBoxManage modifyvm RT-2 --ostype "Debian_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm RT-2 --nic1 hostonly
VBoxManage modifyvm RT-2 --hostonlyadapter1 "vboxnet1"
VBoxManage modifyvm RT-2 --nictype1 virtio
VBoxManage modifyvm RT-2 --macaddress1 0022b0020102

VBoxManage modifyvm RT-2 --nic2 hostonly
VBoxManage modifyvm RT-2 --hostonlyadapter2 "vboxnet7"
VBoxManage modifyvm RT-2 --nictype2 virtio
VBoxManage modifyvm RT-2 --macaddress2 0022b0020702

VBoxManage modifyvm RT-2 --nic3 hostonly
VBoxManage modifyvm RT-2 --hostonlyadapter3 "vboxnet4"
VBoxManage modifyvm RT-2 --nictype3 virtio
VBoxManage modifyvm RT-2 --macaddress3 0022b0020402

VBoxManage modifyvm RT-2 --nic4 bridged
VBoxManage modifyvm RT-2 --bridgeadapter4 eth1
VBoxManage modifyvm RT-2 --nictype4 virtio
VBoxManage modifyvm RT-2 --macaddress4 0022b0020012


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl RT-2 --name "IDE Controller" --add ide
VBoxManage storageattach RT-2 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/vyos-1.1.7-amd64.iso

# Festplatte
VBoxManage storagectl RT-2 --name "SATA Controller" --add sata
VBoxManage createhd --filename "RT-2/RT-2.vdi" --size 2048 --format VDI --variant Fixed
VBoxManage storageattach RT-2 --storagectl "SATA Controller" --medium "RT-2/RT-2.vdi" --port 0 --type hdd


# Serielle Konsole
VBoxManage modifyvm RT-2 --uart1 0x3F8 4
VBoxManage modifyvm RT-2 --uartmode1 server /tmp/RT-2.pipe

# RDP-Konsole
VBoxManage modifyvm RT-2 --vrde on
VBoxManage modifyvm RT-2 --vrdeport 8002
