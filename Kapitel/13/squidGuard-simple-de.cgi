#!/usr/bin/perl
# Beispel-CGI Skript, um dem Benutzer zu erklaeren, aufgrund welcher Regel
# eine URL geblockt worden ist.
#
# Englisches Orginal von P�l Baltzersen 1998
# Deutsche Uebersetzung von Christine Kronberg 2007
# Erweitert fuer die Benutzung unter VyOS  2016
#

$QUERY_STRING = $ENV{'QUERY_STRING'};
$DOCUMENT_ROOT = $ENV{'DOCUMENT_ROOT'};

# Die VyOS Konfiguration erlaubt kein Fragezeichen, welches in einer
# URL die Adresse von den Parametern trennt. Also benutzen wir alternativ
# ein Schr�gstrich und die Werte aus der Variablen REQUEST_URI
if ( ! $QUERY_STRING ) {
  $QUERY_STRING = $ENV{'REQUEST_URI'};
  $QUERY_STRING =~ s!$ENV{'SCRIPT_NAME'}/!!;
}

# Email Adresse des Proxy Administrators:
my $PROXYEMAIL = "proxymaster\@foo.bar";
#
#
$clientaddr = "";
$clientname = "";
$clientuser = "";
$clientgroup = "";
$targetgroup = "";
$url = "";
$time = time;
@day = ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
@month = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");

#$QUERY_STRING =~ m!^/!?!;

while ($QUERY_STRING =~ /^\&?([^&=]+)=([^&=]*)(.*)/) {
  $key = $1;
  $value = $2;
  $QUERY_STRING = $3;
  if ($key =~ /^(clientaddr|clientname|clientuser|clientgroup|targetgroup|url)$/) {
    eval "\$$key = \$value";
  }
  if ($QUERY_STRING =~ /^url=(.*)/) {
    $url = $1;
    $QUERY_STRING = "";
  }
}

if ($url =~ /\.(gif|jpg|jpeg|mpg|mpeg|avi|mov)$/i) {
  print "Content-Type: image/gif\n";
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time);
  printf "Expires: %s, %02d-%s-%02d %02d:%02d:%02d GMT\n\n", $day[$wday],$mday,$month[$mon],$year,$hour,$min,$sec;
  open(GIF, "$DOCUMENT_ROOT/images/blocked.gif");
  while (<GIF>) {
    print;
  }
  close(GIF)
} else {
  print "Content-type: text/html\n";
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time);
  printf "Expires: %s, %02d-%s-%02d %02d:%02d:%02d GMT\n\n", $day[$wday],$mday,$month[$mon],$year,$hour,$min,$sec;
  print "<HTML>\n\n  <HEAD>\n    <TITLE>302 Zugriff verweigert</TITLE>\n  </HEAD>\n\n";
  print "  <BODY BGCOLOR=\"#FFFFFF\">\n";
  if ($srcclass eq "unknown") {
    print "    <P ALIGN=RIGHT>\n";
    print "      <A HREF=\"http://www.squidguard.org/\"><IMG SRC=\"/images/your-logo.gif\"\n";
    print "         BORDER=0></A>\n      </P>\n\n";
    print "    <H1 ALIGN=CENTER>Der Zugriff wurde verweigert, da <BR>dieser Rechner nicht<BR> am Proxy definiert worden ist.</H1>\n\n";
    print "    <TABLE BORDER=0 ALIGN=CENTER>\n";
    print "      <TR><TH ALIGN=RIGHT>Zusatz Informationen</TH><TH ALIGN=CENTER>:</TH><TH ALIGN=LEFT>&nbsp;</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechner Adresse</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientaddr</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechner Name</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientname</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Benutzerkennung</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientuser</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechnergruppe</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$targetgroup</TH></TR>\n";
    print "    </TABLE>\n\n";
    print "    <P ALIGN=CENTER>Sollten diese Informationen nicht korrekt sein, kontaktieren Sie bitte<BR>\n";
    print "      <A HREF=mailto:$PROXYEMAIL>$PROXYEMAIL</A>\n";
    print "    </P>\n\n";
  } elsif ($targetgroup eq "in-addr") {
    print "    <P ALIGN=RIGHT>\n";
    print "      <A HREF=\"http://www.squidguard.org/\"><IMG SRC=\"/images/your-logo.gif\"\n";
    print "         BORDER=0></A>\n      </P>\n\n";
    print "    <H1 ALIGN=CENTER>Zugriff auf IP Adressen URLs sind von diesem Rechner nicht erlaubt.</H1>\n\n";
    print "    <TABLE BORDER=0 ALIGN=CENTER>\n";
    print "      <TR><TH ALIGN=RIGHT>Zusatz Informationen</TH><TH ALIGN=CENTER>:</TH><TH ALIGN=LEFT>&nbsp;</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechner Adresse</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientaddr</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechner Name</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientname</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Benutzerkennung</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientuser</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechnergruppe</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientgroup</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>URL</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$url</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Zielgruppe</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$targetgroup</TH></TR>\n";
    print "    </TABLE>\n\n";
    print "    <P ALIGN=CENTER>Zu der angegebenen IP Adresse konnte kein Domain Name gefunden werden. Der Zugriff auf\n";
    print "    solche Adresse ist gesperrt. <BR>\n";
    print "     Sollten diese Informationen nicht korrekt sein, kontaktieren Sie bitte<BR>\n";
    print "      <A HREF=mailto:$PROXYEMAIL>$PROXYEMAIL</A>\n";
    print "    </P>\n\n";
  } else {
    print "    <P ALIGN=RIGHT>\n";
    print "      <A HREF=\"http://www.squidguard.org/\"><IMG SRC=\"/images/your-logo.gif\"\n";
    print "         BORDER=0></A>\n      </P>\n\n";
    print "    <H1 ALIGN=CENTER>Zugriff verweigert</H1>\n\n";
    print "    <TABLE BORDER=0 ALIGN=CENTER>\n";
    print "      <TR><TH ALIGN=RIGHT>Zusatz Informationen</TH><TH ALIGN=CENTER>:</TH><TH ALIGN=LEFT>&nbsp;</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechner Adresse</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientaddr</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechner Name</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientname</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Benutzerkennung</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientuser</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Rechnergruppe</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$clientgroup</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>URL</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$url</TH></TR>\n";
    print "      <TR><TH ALIGN=RIGHT>Zielgruppe</TH><TH ALIGN=CENTER>=</TH><TH ALIGN=LEFT>$targetgroup</TH></TR>\n";
    print "    </TABLE>\n\n";
    print "    <P ALIGN=CENTER>Sollten diese Informationen nicht korrekt sein, kontaktieren Sie bitte<BR>\n";
    print "      <A HREF=mailto:$PROXYEMAIL>$PROXYEMAIL</A>\n";
    print "    </P>\n\n";
  }
  print "  </BODY>\n\n</HTML>\n";
}
exit 0;
