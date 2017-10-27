#!/bin/bash
## Virtuelle Maschine in VirtualBox aus Vorlage anlegen und einrichten


# run all commands as vbox user

# VM erstellen und registrieren
#wget -q http://mirror.vyos.net/iso/release/1.1.7/vyos-1.1.7-amd64-signed.ova
VBoxManage import /data/vmware/images/vyos-1.1.7-amd64-signed.ova --vsys 0 --ostype "Debian_64" --vmname RT-1 --cpus 1 --memory 512 --unit 10 --ignore --vsys 0 --unit 12 --ignore --vsys 0 --unit 13 --ignore --unit 14 --disk "/home/vbox/VirtualBox VMs/RT-1/disk.vmdk"

# Netzwerkkarten einrichten
VBoxManage modifyvm RT-1 --nic1 bridged
VBoxManage modifyvm RT-1 --bridgeadapter1 eth1.1401
VBoxManage modifyvm RT-1 --nictype1 virtio
VBoxManage modifyvm RT-1 --macaddress1 0022b0010101

VBoxManage modifyvm RT-1 --nic2 bridged
VBoxManage modifyvm RT-1 --bridgeadapter2 eth1.1406
VBoxManage modifyvm RT-1 --nictype2 virtio
VBoxManage modifyvm RT-1 --macaddress2 0022b0010601

VBoxManage modifyvm RT-1 --nic3 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter3 "vboxnet4"
VBoxManage modifyvm RT-1 --nictype3 virtio
VBoxManage modifyvm RT-1 --macaddress3 0022b0010401

VBoxManage modifyvm RT-1 --nic4 bridged
VBoxManage modifyvm RT-1 --bridgeadapter4 eth1
VBoxManage modifyvm RT-1 --nictype4 virtio
VBoxManage modifyvm RT-1 --macaddress4 0022b0010001

VBoxManage modifyvm RT-1 --nic5 bridged
VBoxManage modifyvm RT-1 --bridgeadapter5 eth1.1407
VBoxManage modifyvm RT-1 --nictype5 virtio
VBoxManage modifyvm RT-1 --macaddress5 0022b0010701

# Soundkarte entfernen
VBoxManage modifyvm RT-1 --audio none

# Serielle Konsole
VBoxManage modifyvm RT-1 --uart1 0x3F8 4
VBoxManage modifyvm RT-1 --uartmode1 server /tmp/RT-1.pipe

# RDP-Konsole
VBoxManage modifyvm RT-1 --vrde on
VBoxManage modifyvm RT-1 --vrdeport 8001

# Beschriftung
VBoxManage modifyvm RT-1 --description "Erstellt am `date +%d.%m.%Y` um `date +%H:%M`"


# Das Mounten der virtuellen Festplatte funktioniert nur bei einem Kernel 
# mit Unterstützung für "Network Block Device".

su - # run as root
modprobe nbd
qemu-nbd -c /dev/nbd0 /home/vbox/VirtualBox\ VMs/RT-1/disk.vmdk
mount -o offset=1048576 /dev/nbd0 /mnt

# Konfiguration einspielen
cp RT-1.conf /mnt/boot/1.1.7/live-rw/config/config.boot

# Deutsches Keyboard einstellen
cat <<EOF > /mnt/boot/1.1.7/live-rw/etc/default/keyboard
XKBMODEL="pc105"
XKBLAYOUT="de"
XKBVARIANT="nodeadkeys"
XKBOPTIONS=""
EOF

umount /mnt
qemu-nbd -d /dev/nbd0
exit # root session

# VM starten
VBoxHeadless --startvm RT-1 &
