import vymgmt
import sys

# Liste aller Router. Die Angabe der IPv4- oder IPv6-Adresse ist zwingend.
# Username und Passwort sind optional und nur notwendig, wenn sie sich
# von vyos/vyos unterscheiden
vyos_routers = [
	# RT-1 VyOS 1.1.7
	{
		"addr" : "10.4.1.1"
		#"addr" : "fd00:4::1"
	},

	# RT-4 VyOS 1.2.0-beta1
	{ "addr" : "10.5.1.4" },

	# RT-5 EdgeRouter-X EdgeOS 1.9.1
	{ "addr" : "10.5.1.5" },

	# RT-B Brocade vRouter 5600 5.1R1B
	{ "addr" : "10.5.1.56",
	  "user" : "vyatta",
	  "pass" : "vyatta",
	},
];


for router in vyos_routers:
	# default-Werte setzen
	if 'user' in router :
		username = router["user"]
	else :
		username = 'vyos'

	if 'pass' in router :
		password = router["pass"]
	else :
		password = 'vyos'

	if 'port' in router :
		port = router["port"]
	else :
		port = 22

	# kleine Ausgabe fuer die Kommandozeile
	print( "ssh %s:%s@%s:%d" %
		( username, password, router["addr"], port ) )

	# Objekt der Klasse "Router" erstellen und mit Login-Informationen
	# fuellen. Es erfolgt noch kein SSH-Login
	vyos = vymgmt.Router(
		address=router["addr"],
		user=username,
		password=password,
		port=port
	)

	# SSH-Login zum Router mit den angegebenen Credentials
	vyos.login()

	# Jetzt werden die "operational mode"-Kommandos ausgefuehrt
	print vyos.run_op_mode_command("show version")

	# Konfigurationsaenderungen passieren wie in der VyOS-CLI:
	# configure, set irgendwas, commit, save, exit
	#vyos.configure()
	#vyos.set("protocols static route 203.0.113.0/25 next-hop 192.0.2.20")
	#vyos.delete("protocols static route 203.0.113.0/25")
	#vyos.commit()
	#vyos.save()
	#vyos.exit()

	# bye bye
	vyos.logout()

sys.exit(0)
