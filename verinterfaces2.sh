
echo "-----------------------------"
ip link show
echo "-----------------------------"
ifconfig -a
echo "-----------------------------"
sudo ip link set eth1 up
sudo ip link set eth2 up
sudo ip link set eth3 up
sudo ip link set wlan0 up
echo "-----------------------------"
sudo dhclient eth1
sudo dhclient eth2
sudo dhclient eth3
echo "-----------------------------"
sudo systemctl restart networking
