#!/bin/bash
#


myip=$(curl ifconfig.me -sk)

ip rule add table 137 from ${myip}

baseip=$(echo ${myip} | cut -d"." -f1-3)

ip route add table 137 to ${baseip}.0/24 dev eth0
ip route add table 137 default via ${baseip}.1

echo
