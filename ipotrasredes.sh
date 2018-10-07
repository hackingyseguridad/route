#!/bin/bash

ip addr add 10.0.0.1/8 dev eth0 label eth0:1
ip addr add 172.16.0.1/12 dev eth0 label eth0:2

#Cambiar gateway 
#route add default gw 10.0.0.1 eth0
#route add default gw 192.168.1.1 eth0
