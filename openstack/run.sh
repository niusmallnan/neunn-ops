#! /bin/bash
#
# run.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#
if (($# == 0)); then
usage
    exit
fi

usage()
{
    echo "缺少参数来指定主机"
    echo "run ncloud-compute-1"
}

echo "$1"
# add interface

#install nova
salt "$1" cmd.script salt://openstack/nova_compute_install.sh
sleep 5
# modify nova.conf
salt-cp "$1" conf/nova.conf /etc/nova/nova.conf
salt "$1" cmd.script salt://openstack/modify_nova_conf.sh


# install neutron ml2 plugin
salt "$1" cmd.script salt://openstack/nova_neutron_plugin_install.sh
sleep 5
# modify neutron ml2 conf
salt-cp "$1" conf/neutron.conf /etc/neutron/neutron.conf
salt-cp "$1" conf/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini
salt "$1" cmd.script salt://openstack/modify_ml2_conf.sh

# add ovs bridge
salt "$1" cmd.run "service openvswitch-switch restart"
salt "$1" cmd.run "ovs-vsctl add-br br-int"

# start service
salt "$1" cmd.run "service nova-compute restart"
salt "$1" cmd.run "service neutron-plugin-openvswitch-agent restart"
