#! /bin/bash
#
# glance_install.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#

apt-get update
apt-get install --reinstall python-mysqldb -y
apt-get install --reinstall glance python-glanceclient


rm /var/lib/glance/glance.sqlite
su -s /bin/sh -c "glance-manage db_sync" glance

