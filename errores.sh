#!/bin/bash
sudo ip addr flush dev lo
sudo ifdown --all
sudo ifup --all
sudo service networking restart
