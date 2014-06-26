#! /bin/bash
#
# modify_ml2_conf.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


eth1ip=`ifconfig eth1 | awk '/inet/{print $2}' | awk -F: '{print $2}'`
sed -i 's/INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS/'$eth1ip'/g' /etc/neutron/plugins/ml2/ml2_conf.ini

chown root:neutron /etc/neutron/neutron.conf
chmod 664 /etc/neutron/neutron.conf
chown root:neutron /etc/neutron/plugins/ml2/ml2_conf.ini
chmod 664 /etc/neutron/plugins/ml2/ml2_conf.ini 

