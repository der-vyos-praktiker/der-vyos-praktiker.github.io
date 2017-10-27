#!/bin/bash
## Virtuelle Maschine in VirtualBox aus Vorlage anlegen und einrichten


# run all commands as vbox user

# VM erstellen und registrieren
VBoxManage import /data/vmware/images/vyos-1.1.7-amd64-signed.ova --vsys 0 --ostype "Debian_64" --vmname RT-core --cpus 1 --memory 512 --unit 10 --ignore --vsys 0 --unit 12 --ignore --vsys 0 --unit 13 --ignore --unit 14 --disk "/home/vbox/VirtualBox VMs/RT-core/disk.vmdk"


# Netzwerkkarten einrichten
VBoxManage modifyvm RT-core --nic1 bridged
VBoxManage modifyvm RT-core --bridgeadapter1 eth1
VBoxManage modifyvm RT-core --nictype1 virtio
VBoxManage modifyvm RT-core --macaddress1 0022b0060001

#VBoxManage modifyvm RT-core --nic2 hostonly
#VBoxManage modifyvm RT-core --hostonlyadapter2 "vboxnet6"
VBoxManage modifyvm RT-core --nic2 bridged
VBoxManage modifyvm RT-core --bridgeadapter2 eth1.1406
VBoxManage modifyvm RT-core --nictype2 virtio
VBoxManage modifyvm RT-core --macaddress2 0022b0060606

#VBoxManage modifyvm RT-core --nic3 hostonly
#VBoxManage modifyvm RT-core --hostonlyadapter3 "vboxnet7"
VBoxManage modifyvm RT-core --nic3 bridged
VBoxManage modifyvm RT-core --bridgeadapter3 eth1.1407
VBoxManage modifyvm RT-core --nictype3 virtio
VBoxManage modifyvm RT-core --macaddress3 0022b0060706

# Soundkarte entfernen
VBoxManage modifyvm RT-core --audio none

# Serielle Konsole
VBoxManage modifyvm RT-core --uart1 0x3F8 4
VBoxManage modifyvm RT-core --uartmode1 server /tmp/RT-core.pipe

# RDP-Konsole
VBoxManage modifyvm RT-core --vrde on
VBoxManage modifyvm RT-core --vrdeport 8006

# Beschriftung
VBoxManage modifyvm RT-core --description "Erstellt am `date +%d.%m.%Y` um `date +%H:%M`"


# Festplatte lokal einhaengen
su - # run as root
modprobe nbd
qemu-nbd -c /dev/nbd0 /home/vbox/VirtualBox\ VMs/RT-core/disk.vmdk
mount -o offset=1048576 /dev/nbd0 /mnt

# Konfiguration einspielen
cp RT-core.conf /mnt/boot/1.1.7/live-rw/config/config.boot

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
VBoxHeadless --startvm RT-core &
