# route

# Establece ruta con otras redes en linux

ip route show

sudo route add -net 172.16.0.0/12 gw 192.168.1.1 dev eth0

sudo route add -net 10.0.0.0/8 gw 192.168.1.1 dev eth0

ip route list

#
# www.hackingyseguridad.com
#
# Comandos:
#
# Ver los dispositivos e IP

ifconfig

ip addr show

ip link show

# Establecer IP a un interface

ip addr add 10.1.1.2/16 dev eth1

ip link set eth1 up

# Activar un interface de red

ifconfig eth0 up

ip link set eth0 up

# Desactivar un interface de red:

ifconfig eth0 down

ip link set eth0 down

Setting IP address

# La version simple:

ifconfig eth0 192.168.0.77

ip address add 192.168.0.77 dev eth0

# La versión completa:

ifconfig eth0 192.168.0.77 netmask 255.255.255.0 broadcast 192.168.0.255

ip addr add 192.168.0.77/24 broadcast 192.168.0.255 dev eth0

# Borrar una IP:

ip addr del 192.168.0.77/24 dev eth0

# Incluir alias interface

ifconfig eth0:1 10.0.0.1/8

ip addr add 10.0.0.1/8 dev eth0 label eth0:1

# Incluir una entrada en al tabla de rutas

arp -i eth0 -s 192.168.0.1 00:11:22:33:44:55

ip neigh add 192.168.0.1 lladdr 00:11:22:33:44:55 nud permanent dev eth0

# Establecer resolución ARP a un dispositivo

ifconfig -arp eth0

ip link set dev eth0 arp off

# Ver la table de rutas

route

ip route show

# With ip you can query on which interface a packet to a given IP address would be routed to:

ip route get 192.168.88.77

# Cambiando la tabla de rutas:

route add -net 192.168.3.0/24 dev eth3

ip route add 192.168.3.0/24 dev eth3

# Borrar entradas de la tabla de rutas:

route del -net 192.168.3.0/24 dev eth3

ip route del 192.168.3.0/24 dev eth3

# Establecer ruta:

route add -net 192.168.4.0/24 gw 192.168.4.1

ip route add 192.168.4.0/24 via 192.168.4.1
