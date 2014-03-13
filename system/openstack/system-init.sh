#! /bin/bash
#
# system-init.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


apt-get install -y ntp

apt-get install python-software-properties
add-apt-repository cloud-archive:havana

apt-get update && apt-get -y dist-upgrade
reboot



