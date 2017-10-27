#!/bin/bash
## Virtuelle Maschine in VirtualBox aus Vorlage anlegen und einrichten


# run all commands as vbox user

# VM erstellen und registrieren
VBoxManage import /data/vmware/images/vyos-1.1.7-amd64-signed.ova --vsys 0 --ostype "Debian_64" --vmname RT-2 --cpus 1 --memory 512 --unit 10 --ignore --vsys 0 --unit 12 --ignore --vsys 0 --unit 13 --ignore --unit 14 --disk "/home/vbox/VirtualBox VMs/RT-2/disk.vmdk"


# Netzwerkkarten einrichten
#VBoxManage modifyvm RT-2 --nic1 hostonly
#VBoxManage modifyvm RT-2 --hostonlyadapter1 "vboxnet1"
VBoxManage modifyvm RT-2 --nic1 bridged
VBoxManage modifyvm RT-2 --bridgeadapter1 eth1.1401
VBoxManage modifyvm RT-2 --nictype1 virtio
VBoxManage modifyvm RT-2 --macaddress1 0022b0020102

#VBoxManage modifyvm RT-2 --nic2 hostonly
#VBoxManage modifyvm RT-2 --hostonlyadapter2 "vboxnet7"
VBoxManage modifyvm RT-2 --nic2 bridged
VBoxManage modifyvm RT-2 --bridgeadapter2 eth1.1407
VBoxManage modifyvm RT-2 --nictype2 virtio
VBoxManage modifyvm RT-2 --macaddress2 0022b0020702

VBoxManage modifyvm RT-2 --nic3 hostonly
VBoxManage modifyvm RT-2 --hostonlyadapter3 "vboxnet4"
VBoxManage modifyvm RT-2 --nictype3 virtio
VBoxManage modifyvm RT-2 --macaddress3 0022b0020402

VBoxManage modifyvm RT-2 --nic4 bridged
VBoxManage modifyvm RT-2 --bridgeadapter4 eth1
VBoxManage modifyvm RT-2 --nictype4 virtio
VBoxManage modifyvm RT-2 --macaddress4 0022b0020002

# Soundkarte entfernen
VBoxManage modifyvm RT-2 --audio none

# Serielle Konsole
VBoxManage modifyvm RT-2 --uart1 0x3F8 4
VBoxManage modifyvm RT-2 --uartmode1 server /tmp/RT-2.pipe

# RDP-Konsole
VBoxManage modifyvm RT-2 --vrde on
VBoxManage modifyvm RT-2 --vrdeport 8002

# Beschriftung
VBoxManage modifyvm RT-2 --description "Erstellt am `date +%d.%m.%Y` um `date +%H:%M`"


# Festplatte lokal einhaengen
su - # run as root
modprobe nbd
qemu-nbd -c /dev/nbd0 /home/vbox/VirtualBox\ VMs/RT-2/disk.vmdk
mount -o offset=1048576 /dev/nbd0 /mnt

# Konfiguration einspielen
cp RT-2.conf /mnt/boot/1.1.7/live-rw/config/config.boot

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
VBoxHeadless --startvm RT-2 &
