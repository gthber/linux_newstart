#!/usr/bin/env bash

if [ ! -e /usr/bin/proxychains ]; then
	sudo apt-get install proxychains
fi

if [ ! -e /usr/bin/fping ]; then
        sudo apt-get install fping
fi


if [ $# != 2 ]; then
        echo "help your to find the best available proxy server sort by speed"
        echo "usage:`basename $0` -3 filename (http/https filter)"
        echo "     :`basename $0` -4 filename (socks4 filter)"
        echo "     :`basename $0` -5 filename (socks5 filter)"
        exit  -1
fi




tmpfile=/tmp/$RANDOM

cat <<BOF >$tmpfile
random_chain
quiet_mode
proxy_dns
tcp_read_time_out 20000
tcp_connect_time_out 2000
[ProxyList]
BOF


cat $2|grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}"|awk '{print $1,$2}' > /tmp/hostlist
cat /tmp/hostlist|awk '{print $1}'|xargs -I % sh -c 'fping -c1 -t210 %' > /tmp/ping_host
cat /tmp/ping_host |grep bytes|awk '{print $1,$6}'|uniq|sort -k2 -g > /tmp/sort_ping_host
cat /tmp/sort_ping_host|awk '{print $1}'|xargs -I % sh -c 'cat /tmp/hostlist|grep %' > /tmp/host_result

if [ ${1} == '-3' ]; then
        head -50 /tmp/host_result|awk '{print "http",$1,$2}' > /tmp/fastproxylist
fi

if [ ${1} == '-4' ]; then
        head -50 /tmp/host_result|awk '{print "socks4",$1,$2}' > /tmp/fastproxylist
fi

if [ ${1} == '-5' ]; then
        head -50 /tmp/host_result|awk '{print "socks5",$1,$2}' > /tmp/fastproxylist
fi

rm -rf /tmp/hostlist /tmp/ping_host /tmp/sort_ping_host /tmp/host_result



cat /tmp/fastproxylist >> $tmpfile
cat $tmpfile
sudo mv $tmpfile /etc/proxychains.conf
rm $tmpfiles
less /etc/proxychains.conf


