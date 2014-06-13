#! /bin/bash
#
# modify_nova_conf.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#

chown nova:nova /etc/nova/nova.conf
chmod 664 /etc/nova/nova.conf

eth0ip=`ifconfig eth0 | awk '/inet/{print $2}' | awk -F: '{print $2}'`

sed -i 's/MANAGE_IP/'$eth0ip'/g' /etc/nova/nova.conf
sed -i 's/VNC_PROXY_IP/'$eth0ip'/g' /etc/nova/nova.conf




