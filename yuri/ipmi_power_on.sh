#! /bin/bash
#
# power_on.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#
USER="neunn"
PASSWD="Neunn@123"

power_op(){
    ipmitool -I lanplus -H $1 -U ${USER} -P ${PASSWD} power $2
}


ips="192.168.0.101 192.168.0.103 192.168.0.104 192.168.0.105 192.168.0.106 192.168.0.107 192.168.0.108"
for ip in ${ips}
do
    echo ${ip}
    power_op ${ip} on
done


