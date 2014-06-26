#! /bin/bash
#
# install_vxlan.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


salt-cp "$1" conf/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini

salt "$1" cmd.script salt://openstack/modify_ml2_conf.sh

salt "$1" cmd.run "service openvswitch-switch restart"
salt "$1" cmd.run "service nova-compute restart"
salt "$1" cmd.run "service neutron-plugin-openvswitch-agent restart"
