#!/usr/bin/perl
# Zweck: Generiere eine lange ACL im VyOS-Format

# Ausgabe direkt in die VyOS Konfiguration übernehmen mit
# $ configure
# $ source <(/home/vyos/generate_acl.pl)
# $ commit

my $start_rule_number = 200;
my $end_rule_number   = 2000;
my $schrittweite      = 1;


### no customizing below this line
my @action    = ( qw/drop reject accept inspect/ );
my @protocol  = ( qw/tcp udp/ );
my @direction = ( qw/source destination/ );

for ( my $c=$start_rule_number; $c <= $end_rule_number; $c+=$schrittweite ) {

	printf(	"set firewall name ACL-TEST rule %d action %s\n",
		$c,
		'accept'	# $action[ int(rand( 1+$#action )) ]
	);


	if ( int(rand(2)) ) {	# filter by port
		printf	"set firewall name ACL-TEST rule %d protocol %s\n",
			$c, $protocol[ int(rand( 1+$#protocol )) ];

		# don't block ports that are required for real communication
		my $random_port = int( rand( 65535 ));
		$random_port++ if $random_port == 5001;
		$random_port++ if $random_port == 22;

		printf	"set firewall name ACL-TEST rule %d %s port %d\n",
			$c, $direction[ int(rand( 1+$#direction )) ], $random_port;

	} else {		# filter by IP address
		printf(	"set firewall name ACL-TEST rule %d %s address %d.%d.%d.%d/%d\n",
			$c, $direction[ int(rand( 1+$#direction )) ],
			200 + int( rand( 20 )), int( rand( 255 )),	# IPv4 address
			int( rand( 255 )), int( rand( 255 )),
			24 + int( rand( 6 ))				# mask
		);
	}
}

exit( 0 );
