#! /bin/bash
#
# run_local.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#

#apt http proxy
cp conf_yhr/90curtin-aptproxy /etc/apt/apt.conf.d/90curtin-aptproxy
chown root:root /etc/apt/apt.conf.d/90curtin-aptproxy

# nova-compute
sh nova_compute_install.sh
cp conf_yhr/nova.conf /etc/nova/nova.conf
sh modify_nova_conf.sh

# neutron
sh nova_neutron_plugin_install.sh
cp conf_yhr/neutron.conf /etc/neutron/neutron.conf
cp conf_yhr/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
sh modify_ml2_conf.sh

service openvswitch-switch restart
ovs-vsctl add-br br-int

service nova-compute restart
service neutron-plugin-openvswitch-agent restart
