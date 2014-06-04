#!/bin/bash

DIR="/path/where/saving/ip/addresses"
NOWIP=$(wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
LOCLANIP=$(/sbin/ifconfig eth0 | grep 'inet addr' | cut -d ':' -f 2 | awk '{print $1}')
LOCWLANIP=$(/sbin/ifconfig wlan0 | grep 'inet addr' | cut -d ':' -f 2 | awk '{print $1}')

# read the last known global ip (if not just rebooted)
if [ "$1" != "reboot" ]
	then
		if [ -f "$DIR/currentip.txt" ]
			then
				LASTIP=$(cat $DIR/currentip.txt)
			else
				LASTIP="999.999.999.999"
		fi
	else
		LASTIP="999.999.999.999"
fi

# read the last known local ip
if [ -f "$DIR/currentlocip.txt" ]
	then
		LASTLOCIP=$(cat $DIR/currentlocip.txt)
	else
		LASTLOCIP="999.999.999.999"
fi

# send mail and update files with ip addresses (if some differences)
if [ "$LASTIP" != "$NOWIP" ] || [ "$LASTLOCIP" != "$LOCLANIP" -a "$LASTLOCIP" != "$LOCWLANIP" ]
        then
        	echo "To: your@mail.com" > $DIR/.mail.txt
                echo "From: your@mail.com" >> $DIR/.mail.txt
                echo "Subject: IPs" >> $DIR/.mail.txt
                echo -e  >> $DIR/.mail.txt
                if [ "$1" == "reboot" ]
                        then
                                echo "REBOOTED --- " >> $DIR/.mail.txt
                fi
                echo "Global: $NOWIP" >> $DIR/.mail.txt   
                if [ "$LOCWLANIP" != "" ]
                        then
                                echo " --- Local WLAN: $LOCWLANIP" >> $DIR/.mail.txt
                                echo "$LOCWLANIP" > $DIR/currentlocip.txt
                fi
                if [ "$LOCLANIP" != "" ]
                        then
                                echo " --- Local LAN: $LOCLANIP" >> $DIR/.mail.txt
                                echo "$LOCLANIP" > $DIR/currentlocip.txt
                fi
                /usr/sbin/ssmtp your@mail.com < $DIR/.mail.txt
                echo "$NOWIP" > $DIR/currentip.txt
fi
