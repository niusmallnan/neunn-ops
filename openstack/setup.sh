#! /bin/bash
#
# setup.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#

mkdir -p /srv/salt/openstack
cp modify_* /srv/salt/openstack/
cp nova_* /srv/salt/openstack/
cp install_ntp.sh /srv/salt/openstack/
