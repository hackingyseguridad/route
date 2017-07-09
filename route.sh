#!/bin/bash
echo 
echo "Ruta ..."
echo 
ip route show
sudo route add -net 172.16.0.0/12 gw 192.168.1.1 dev eth0
sudo route add -net 10.0.0.0/8 gw 192.168.1.1 dev eth0
ip route list
