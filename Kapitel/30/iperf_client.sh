#!/bin/bash

INTERFACE=eth0

for MTU in 1420 1280 1024 512 256 128 88 ; do
  echo "*** Benchmarking with MTU ${MTU} Bytes"
  sudo ifconfig ${INTERFACE} mtu ${MTU}
  sleep 2
  iperf --client 10.2.1.3 --window 128K --time 60 --interval 60 | grep bit
done

# reset interface MTU
sudo ifconfig ${INTERFACE} down
sudo ifconfig ${INTERFACE} mtu 1500
sudo ifconfig ${INTERFACE} up
