#! /bin/bash
#
# add_fiber_iface.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#

ETH0_IP=`ifconfig eth0 | awk '/inet/{print $2}' | awk -F: '{print $2}' | awk -F "." '{print $4}'`
cat>>/etc/network/interfaces<<EOF
auto vlan103
iface vlan103 inet static
    address 172.28.5.$ETH0_IP
    netmask 255.255.255.0
    vlan-raw_device eth5
EOF



