#!/bin/bash
apt update && apt install --yes mariadb-client speedtest-cli
chmod +x speedtest-mysql.sh
a=30 #In Welchem Abstand soll das SQL Script ausgeführt werden in min


MYDIR=$(dirname "$(readlink -e "$0")")
my_name=$(basename -- "$0")
pfad=$(echo "$MYDIR/speedtest-mysql.sh")


echo "*/$a * * * * $pfad 2>&1" > /etc/crontab
