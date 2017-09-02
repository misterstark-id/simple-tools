#!/bin/bash
USERID="205172925"
KEY="412026819:AAFbtaFjF43h7VCtgXamhjp_useMLdky6rQ"
TIMEOUT="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
DATE_EXEC="$(date "+%d %b %Y %H:%M")"
TMPFILE='/tmp/ipinfo-$DATE_EXEC.txt'
if [ -n "$SSH_CLIENT" ]; then
	IP=$(echo $SSH_CLIENT | awk '{print $1}')
	PORT=$(echo $SSH_CLIENT | awk '{print $3}')
	HOSTNAME=$(hostname)
	IPADDR=$(hostname -I | awk '{print $2}')
	curl http://ipinfo.io/$IP -s -o $TMPFILE
	CITY=$(cat $TMPFILE | jq '.city' | sed 's/"//g')
	REGION=$(cat $TMPFILE | jq '.region' | sed 's/"//g')
	COUNTRY=$(cat $TMPFILE | jq '.country' | sed 's/"//g')
	ORG=$(cat $TMPFILE | jq '.org' | sed 's/"//g')
	TEXT="$DATE_EXEC: ${USER} logged in to $HOSTNAME ($IPADDR) from $IP - $ORG - $CITY, $REGION, $COUNTRY on port $PORT"
	curl -s --max-time $TIMEOUT --retry 5 --retry-delay 2 --retry-max-time $TIMEOUT -d "chat_id=$USERID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null 2>&1 &
	rm $TMPFILE
fi

