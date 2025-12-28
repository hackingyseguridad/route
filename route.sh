#!/bin/bash

# simple script en bash shell para cambiar la  metrica de los interfaces comando ifmetric
# ip route show scope host table all
# @antonio_taboada

echo 
echo "Ruta ..."
echo 
ip route show
route add -net 172.16.0.0/12 gw 192.168.1.1 dev eth0
route add -net 10.0.0.0/8 gw 192.168.1.1 dev eth0
ip route list
