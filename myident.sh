#!/usr/bin/bash
###This scripts tells my identity over the Net
#User Defined Variables

#check requirements
requirements=$(which toilet)
if [ "$requirements" == "" ];then
echo "please install toilet...Installation apt install toilet"
exit 2
fi
#colors
cyan='\e[0;36m'
red='\e[1;31m'
blue='\e[1;34m'
okegreen='\033[92m'
white='\e[1;37m'
RESET="\033[00m" 
color='toilet -f term -t -F gay'

#get interfaces
interfaces=$(ip r | grep 'default via' | tail -n3 | awk '{print $5}')
for i in $interfaces
do

#get local ip addresses
localip=$(ifconfig $i | grep inet | head -n1 | awk '{print $2}')
if [ "$localip" = "" ]
then
	localip="Not connected"
	http_pub_id="Not connected"
	https_pub_id="Not connected"
	host_http="Not connected"
	host_https="Not connected"
else
	http_pub_id=$(timeout 5 curl -s http://ident.me)
	https_pub_id=$(timeout 6 curl -s https://2ip.ru)
fi

#Get host names
if [ "$http_pub_id" = "" ]
then
host_http="Not connected"
else
host_http=`whois $http_pub_id | grep -i "netname" | cut -d ":" -f 2`
fi

if [ "$https_pub_id" = "" ]
then
host_https="Not connected"
else
host_https=`whois $https_pub_id | grep -i "netname" | cut -d ":" -f 2`
fi

#print ip
echo -e $red   " INTERFACE: $blue $i $RESET"         
echo -e $cyan    "  LOCAL IP  :$RESET" $okegreen $localip $RESET
echo -e $white   "    HTTP-PUBLIC IP :$RESET" $http_pub_id "<>" $host_http | $color
echo -e $okegreen"      HTTPS-PUBLIC IP :$RESET" $https_pub_id "<>" $host_https
done
