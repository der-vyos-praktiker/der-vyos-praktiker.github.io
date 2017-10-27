#!/bin/bash

# Speedtest starten und Wert für Upload ermitteln
SPEEDTEST=$(/usr/bin/speedtest.py --csv)
if [ $? -eq 0 ]; then
  UPLOAD=$(echo ${SPEEDTEST} | awk 'BEGIN { FS = "," } ; { print $8 }')
  printf "Upload Bandbreite %0.0f bit/s\n" ${UPLOAD}
else
  echo "Fehler beim Ermitteln der Upload Bandbreite"
  exit 1
fi

# Default-Route aus der Routingtabelle holen
WAN_IF=$(cat <<EOF | /bin/vbash
source /opt/vyatta/etc/functions/script-template
run show ip route 0.0.0.0/0 | grep ', via'
EOF
)

# Welches Interface nutzt die Default-Route?
WAN_IF=`echo ${WAN_IF} | awk '{ print $4 }'`
if [ -z ${WAN_IF} ] ; then
  echo "Fehler: WAN-Interface nicht gefunden"
  exit 2
else
  echo "Interface zum Internet: ${WAN_IF}"
fi

# Traffic-Shaper einrichten
cat <<EOF | /bin/vbash
source /opt/vyatta/etc/functions/script-template
configure

delete traffic-policy shaper UPLOAD
set traffic-policy shaper UPLOAD bandwidth ${UPLOAD}bit
set traffic-policy shaper UPLOAD default bandwidth ${UPLOAD}bit
set traffic-policy shaper UPLOAD default burst 15k
set traffic-policy shaper UPLOAD default ceiling 100%
set traffic-policy shaper UPLOAD default queue-type fair-queue

delete interfaces ethernet ${WAN_IF} traffic-policy out UPLOAD
set interfaces ethernet ${WAN_IF} traffic-policy out UPLOAD
commit
EOF
echo "Traffic-Shaper eingerichtet"
