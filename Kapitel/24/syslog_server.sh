#!/bin/vbash

# Session initialisieren
VYATTA_CFG_SESSION=$(cli-shell-api getSessionEnv $PPID)
eval $VYATTA_CFG_SESSION

cli-shell-api setupSession
cli-shell-api inSession

if [ $? -ne 0 ]; then
  echo "Fehler beim Beginn der Konfiguration"
  exit 1
fi

# Syslog-Server vorhanden?
cli-shell-api exists  system syslog host

if [ $? -eq 0 ]; then
  echo "Syslog-Server bereits vorhanden:"
  cli-shell-api showCfg system syslog host
else
  echo "Neuen Syslog-Server einrichten"

  # Lab-Server als Syslog-Host einrichten
  ${vyatta_sbindir}/my_set system syslog host 10.4.1.7 facility local0

  # Aenderungen aktivieren
  ${vyatta_sbindir}/my_commit

  if [ $? -eq 0 ]; then
    # Erfolgreiche Aenderung? Speichern...
    ${vyatta_sbindir}/vyatta-save-config.pl
  else
    echo "Aenderung fehlgeschlagen"
    exit 2
  fi
fi

# Session erfolgreich beenden
cli-shell-api teardownSession
exit 0
