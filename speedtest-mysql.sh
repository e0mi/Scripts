#!/bin/bash


' Weiter Wntwicklung des Scripts https://github.com/ZephrFish/RandomScripts/blob/master/speedCronIFTTT.sh
# Mysql Daten
speedtestserver=3692
mysqllogin=speedy
mysqlpassword=V8Q1m6EjqdlvibkQ
mysqldb=speedy
mysqlip=37.187.118.203
pcip="192.168.4.4" #work computer
id=1

# Temporary file holding speedtest-cli output
user=$USER
if test -z $user; then
  user=$USERNAME
fi
log=/tmp/$user/speedtest-mysql.log

# Local functions
str_extract() {
 pattern=$1
 # Extract
 res=`grep "$pattern" $log | sed "s/$pattern//g"`
 # Drop trailing ...
 res=`echo $res | sed 's/[.][.][.]//g'`
 # Trim
 res=`echo $res | sed 's/^ *//g' | sed 's/ *$//g'`
 echo $res
}

mkdir -p `dirname $log`

start=`date +"%Y-%m-%d %H:%M:%S"`

echo "Speedtest started at : $start"

# Query Speedtest
/usr/bin/speedtest-cli --server $speedtestserver --share > $log

stop=`date +"%Y-%m-%d %H:%M:%S"`

echo "Speedtest ended at : $stop"

# Parse
from=`str_extract "Testing from "`
from_ip=`echo $from | sed 's/.*(//g' | sed 's/).*//g'`
from=`echo $from | sed 's/ (.*//g'`

server=`str_extract "Hosted by "`
server_ping=`echo $server | sed 's/.*: //g'`
server=`echo $server | sed 's/: .*//g'`
server_dist=`echo $server | sed 's/.*\\[//g' | sed 's/\\].*//g'`
server=`echo $server | sed 's/ \\[.*//g'`

download=`str_extract "Download: "`
upload=`str_extract "Upload: "`
share_url=`str_extract "Share results: "`


# Standardize units?
if test "$1" = "--standardize"; then
  download=`echo $download | sed 's/Mbits/Mbit/'`
  upload=`echo $upload | sed 's/Mbits/Mbit/'`
fi


# Test if my Main computer is on 
if ping -c 1 $pcip >/dev/null
then
  pcison=true
else
  pcison=false
fi

echo "PCIsOn : $pcison"

# Send to Local MySQL

value1=`echo $server_ping | cut -d" " -f1`
value2=`echo $download | cut -d" " -f1`
value3=`echo $upload | cut -d" " -f1` 


sql="INSERT INTO speedtest (id,server,datestart,datestop,ping,dl,ul,ispcon,ip) VALUES ('$id','$speedtestserver','$start','$stop','$server_ping','$download','$upload','$pcison','$from_ip');"

echo "$sql" | mysql -u$mysqllogin -p$mysqlpassword -h$mysqlip $mysqldb 
