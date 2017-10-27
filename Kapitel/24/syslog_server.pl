#!/usr/bin/perl
use lib '/opt/vyatta/share/perl5';
use Vyatta::Config;
$config = new Vyatta::Config;

$neuer_server = '10.4.1.7';

# Sind Syslog-Server eingerichtet?
if ( $config->existsOrig("system syslog host") ) {
  for my $host ( $config->listEffectiveNodes("system syslog host") ) {
    if ( $host eq $neuer_server ) {
      print "Syslog-Server $neuer_server ist bereits vorhanden\n";
      exit 0;
    }
  }
}

# Das Kommando wird jetzt in configure+commit gewickelt...
my $cmd = "source /opt/vyatta/etc/functions/script-template\n".
  "configure\n".
  "set system syslog host $neuer_server facility local0\n".
  "commit";
$cmd = "echo \"$cmd\" | /bin/vbash";

# ... und ausgeführt
system( $cmd );

if ( $? ) {    # Fehlerbehandlung
  print "Fehler beim Ausfuehren von 'commit'\n";
  exit 1;
} else {
  exit 0;
}
