#! /bin/bash
#
# nova_neutron_plugin_install.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


sed -i 's/#net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=0/g' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=0/g' /etc/sysctl.conf
sysctl -p
apt-get install neutron-common neutron-plugin-ml2 neutron-plugin-openvswitch-agent -y
apt-get install python-mysqldb -y

