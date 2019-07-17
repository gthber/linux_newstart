#!/usr/bin/env bash
#scan the network host ip mac and device-name

if [ ! -e /usr/bin/nmap ]; then
	echo "please install nmap first"
	sudo apt-get install nmap
fi


ip=`ifconfig|grep  -Eo  "([0-9]{1,3}\.){3}"|grep -v ^127|grep -v ^255|uniq`'0/24'

sudo nmap -sn -PO -PR ${ip} |awk '/^Nmap scan/{IP=$5};/^MAC/{print IP,"\011",$3,"\011",$4,$5,$6,$7};{next}' > /tmp/sc.log
sudo nmap -sn -PO -PR ${ip} |awk '/^Nmap scan/{IP=$5};/^MAC/{print IP,"\011",$3,"\011",$4,$5,$6,$7};{next}' >> /tmp/sc.log
cnt=`cat /tmp/sc.log|sort|uniq|wc -l`
echo "online host count : ${cnt}"
echo "[ip]		 [mac]			 [device]"
cat /tmp/sc.log|sort|uniq
rm /tmp/sc.log
