#!/bin/bash
iwconfig
ifconfig
ifconfig wlan0 up
ifup wlan0
iwlist wlan0 scanning
nmcli device wifi
nmcli d wifi connect hackingyseguridad password 12345 iface wlan0
dhclient wlan0
iwconfig wlan0
