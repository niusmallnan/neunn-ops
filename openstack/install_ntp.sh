#! /bin/bash
#
# install_ntp.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


apt-get install --reinstall ntp -y

echo "server 10.0.0.1 perfer" >> /etc/ntp.conf"

service ntp restart




