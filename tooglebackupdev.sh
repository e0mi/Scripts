#! /bin/bash
sonoff="192.168.178.68"
host="home.stauder-mail.de"
user=

curl http://$sonoff/cm?cmnd=Power%20On

if ping -c 1 $host >/dev/null
	then
		pcison=true
	else
		pcison=false
	fi
if [ $pcison == "true" ]; then
	./littlebackup.sh
	ssh $user@$host 'shutdown -h now'
	fi
sleep 5m

curl http://$sonoff/cm?cmnd=Power%20off

