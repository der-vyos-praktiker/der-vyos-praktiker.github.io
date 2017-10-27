#!/bin/bash
## Virtuelle Maschine in VirtualBox anlegen und einrichten


# VM erstellen und registrieren
VBoxManage createvm --name "labsrv" --register
VBoxManage modifyvm labsrv --memory 1024
VBoxManage modifyvm labsrv --description "VyOS Lab"
VBoxManage modifyvm labsrv --ostype "Redhat_64"

# Netzwerkkarten einrichten
VBoxManage modifyvm labsrv --nic1 bridged
VBoxManage modifyvm labsrv --bridgeadapter1 eth1
VBoxManage modifyvm labsrv --nictype1 virtio
VBoxManage modifyvm labsrv --macaddress1 0022b0070007

VBoxManage modifyvm labsrv --nic2 hostonly
VBoxManage modifyvm labsrv --hostonlyadapter2 "vboxnet4"
VBoxManage modifyvm labsrv --nictype2 virtio
VBoxManage modifyvm labsrv --macaddress2 0022b0070407


# CD-ROM Laufwerk (für Installation)
VBoxManage storagectl labsrv --name "IDE Controller" --add ide
VBoxManage storageattach labsrv --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/CentOS-7-x86_64-DVD-1511.iso

# Festplatte
VBoxManage storagectl labsrv --name "SATA Controller" --add sata
VBoxManage createhd --filename "labsrv/labsrv.vdi" --size 10240 --format VDI --variant Fixed
VBoxManage storageattach labsrv --storagectl "SATA Controller" --medium "labsrv/labsrv.vdi" --port 0 --type hdd


# RDP-Konsole
VBoxManage modifyvm labsrv --vrde on
VBoxManage modifyvm labsrv --vrdeport 8007
