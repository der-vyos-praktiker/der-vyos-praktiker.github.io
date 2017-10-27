#!/bin/bash
## Virtuelle Maschine in VirtualBox aus Vorlage anlegen und einrichten


# run all commands as vbox user

# VM erstellen und registrieren
VBoxManage import /data/vmware/images/vyos-1.1.7-amd64-signed.ova --vsys 0 --ostype "Debian_64" --vmname RT-3 --cpus 1 --memory 512 --unit 10 --ignore --vsys 0 --unit 12 --ignore --vsys 0 --unit 13 --ignore --unit 14 --disk "/home/vbox/VirtualBox VMs/RT-3/disk.vmdk"


# Netzwerkkarten einrichten
VBoxManage modifyvm RT-3 --nic1 hostonly
VBoxManage modifyvm RT-3 --hostonlyadapter1 "vboxnet2"
VBoxManage modifyvm RT-3 --nictype1 virtio
VBoxManage modifyvm RT-3 --macaddress1 0022b0030203

#VBoxManage modifyvm RT-3 --nic2 hostonly
#VBoxManage modifyvm RT-3 --hostonlyadapter2 "vboxnet6"
VBoxManage modifyvm RT-3 --nic2 bridged
VBoxManage modifyvm RT-3 --bridgeadapter2 eth1.1406
VBoxManage modifyvm RT-3 --nictype2 virtio
VBoxManage modifyvm RT-3 --macaddress2 0022b0030603

VBoxManage modifyvm RT-3 --nic3 bridged
VBoxManage modifyvm RT-3 --bridgeadapter3 eth1
VBoxManage modifyvm RT-3 --nictype3 virtio
VBoxManage modifyvm RT-3 --macaddress3 0022b0030003

# Soundkarte entfernen
VBoxManage modifyvm RT-3 --audio none

# Serielle Konsole
VBoxManage modifyvm RT-3 --uart1 0x3F8 4
VBoxManage modifyvm RT-3 --uartmode1 server /tmp/RT-3.pipe

# RDP-Konsole
VBoxManage modifyvm RT-3 --vrde on
VBoxManage modifyvm RT-3 --vrdeport 8003

# Beschriftung
VBoxManage modifyvm RT-3 --description "Erstellt am `date +%d.%m.%Y` um `date +%H:%M`"


# Festplatte lokal einhaengen
su - # run as root
modprobe nbd
qemu-nbd -c /dev/nbd0 /home/vbox/VirtualBox\ VMs/RT-3/disk.vmdk
mount -o offset=1048576 /dev/nbd0 /mnt

# Konfiguration einspielen
cp RT-3.conf /mnt/boot/1.1.7/live-rw/config/config.boot

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
VBoxHeadless --startvm RT-3 &
