#!c:/perl/bin/perl.exe
# purpose: show connection information to calling web browser

print "Content-type: text/html\n\n";

print <<EOF;
<html>
 <head>
  <style>
   table { table-layout:fixed; }
   table td {
	overflow: hidden;
	width: 5em;
	height: 5em;
   }
  </style>
 </head>
 <body>
EOF

printf "Welcome to the <i>Internet</i> (%s).<br/>\n",
	$ENV{ 'SERVER_NAME' };
print "Client IP is: " . $ENV{ 'REMOTE_ADDR' } . "<br/>\n";
printf "Timestamp %s<br/>\n", timef( time );


# color table to easily see a change in this web page
print	"<table>\n".
	" <tr>\n";
for my $c ( 0 .. 4 ) {
	printf( "  <td bgcolor='#%02x%02x%02x'>&nbsp;</td>\n",
		int( rand( 256 )),
		int( rand( 256 )),
		int( rand( 256 )),
	);
}
print	" </tr>\n".
	"</table>\n";


# Apache %ENV varialbe
print "<br/><br/><code>\n";
foreach (keys %ENV) {
	printf "%s: %s<br/>\n", $_, $ENV{ $_ };
}

print <<EOF;
</code>
 </body>
</html>
EOF

sub timef ($) {
	my ($time) = @_;
	my ($sec,$min,$hour,$day,$mon,$year,$yday,$tz) = localtime( $time );
	return sprintf( "%04d/%02d/%02d %02d:%02d:%02d",
		$year+1900, $mon+1, $day, $hour, $min, $sec);
}
