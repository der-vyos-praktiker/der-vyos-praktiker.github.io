#!/usr/bin/perl
# Diese Skript generiert eine proxy.pac für Webbrowser.

# welche Proxyserver gibt es?
my @proxy_server = ( qw/10.1.1.5 10.1.1.6/ );

print	"Content-type: application/x-ns-proxy-autoconfig\n\n";

print	"function FindProxyForURL(url, host) {\n";

# waehle einen zufaelligen Eintrag aus
my $bevorzugter_proxy = int( rand( @proxy_server ));

# Der ausgewaehlten Proxyserver wird primaerer Proxy und der andere Backup
printf	"  return \"PROXY %s:3128; PROXY %s:3128\";\n",
	$proxy_server[  $bevorzugter_proxy ],
	$proxy_server[ !$bevorzugter_proxy ];

print	"}\n";

exit 0;
