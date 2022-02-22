#/bin/bash
eth0_ip=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1) ; eth0_gw=$(ip route list dev eth0 | awk '{print $1}' | tail -1 | cut -d'/' -f1)
echo
echo "Interface Eth0:" "ip:" $eth0_ip, "Gateway", $eth0_gw

eth1_ip=$(ip -o -4 addr list eth1 | awk '{print $4}' | cut -d/ -f1) ; eth1_gw=$(ip route list dev eth1 | awk '{print $1}' | tail -1 | cut -d'/' -f1)
echo
echo "Interface Eth1:" "ip:" $eth1_ip, "Gateway", $eth1_gw

eth2_ip=$(ip -o -4 addr list eth2 | awk '{print $4}' | cut -d/ -f1) ; eth2_gw=$(ip route list dev eth2 | awk '{print $1}' | tail -1 | cut -d'/' -f1)
echo
echo "Interface Eth2:" "ip:" $eth2_ip, "Gateway", $eth2_gw

