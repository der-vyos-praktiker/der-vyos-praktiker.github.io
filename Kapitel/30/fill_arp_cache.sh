#!/bin/bash
NEIGHBORS=$(/sbin/ip route list | grep via | awk '{print $3}')
for NEIGHBOR in ${NEIGHBORS} ; do
  arp -an | grep ${NEIGHBOR} >/dev/null  ||  /bin/ping -t1 -c1 -W1 ${NEIGHBOR} >/dev/null
done
