#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "cl-2" --register
VBoxManage modifyvm cl-2 --memory 512
VBoxManage modifyvm cl-2 --description "VyOS Lab"
VBoxManage modifyvm cl-2 --ostype "Windows XP (32-bit)"

# Netzwerkkarten einrichten
VBoxManage modifyvm cl-2 --nic1 hostonly
VBoxManage modifyvm cl-2 ----hostonlyadapter1 vboxnet2
VBoxManage modifyvm cl-2 --nictype1 virtio
VBoxManage modifyvm cl-2 --macaddress1 0022b0120225


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl cl-2 --name "IDE Controller" --add ide
VBoxManage storageattach cl-2 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/winxp_sp2_en.iso

# Festplatte
VBoxManage storagectl cl-2 --name "SATA Controller" --add sata
VBoxManage createhd --filename "cl-2/cl-2.vdi" --size 10240 --format VDI --variant Fixed
VBoxManage storageattach cl-2 --storagectl "SATA Controller" --medium "cl-2/cl-2.vdi" --port 0 --type hdd


# RDP-Konsole
VBoxManage modifyvm cl-2 --vrde on
VBoxManage modifyvm cl-2 --vrdeport 8012
