# /bin/bash
t="1"
rep="20"

COUNTER=0
         while [  $COUNTER -lt $rep ]; do
		stty -F /dev/ttyUSB0 57600
 		cat /home/user/te > /dev/ttyUSB0
		echo -e "\x15n\x15n\x15n \x1B\x6D" > /dev/ttyUSB0
		
		
		sleep $t 
             let COUNTER=COUNTER+1 
         done
