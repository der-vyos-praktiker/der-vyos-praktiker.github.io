#!/bin/bash
## Virtuelle Netze anlegen und einrichten

# vboxnet erstellen
for value in {0..7}; do
  VBoxManage hostonlyif create
done

# vboxnet konfigurieren
vboxmanage hostonlyif ipconfig vboxnet1 --ip 10.1.1.181
vboxmanage hostonlyif ipconfig vboxnet2 --ip 10.2.1.181
vboxmanage hostonlyif ipconfig vboxnet3 --ip 10.3.1.181
vboxmanage hostonlyif ipconfig vboxnet4 --ip 10.4.1.181
vboxmanage hostonlyif ipconfig vboxnet6 --ip 192.0.2.181
vboxmanage hostonlyif ipconfig vboxnet7 --ip 198.51.100.181
