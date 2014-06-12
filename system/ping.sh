#! /bin/bash
#
# ping.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#
# 列出网络上的所有的活动主机
#

for ip in 192.168.1.{1..255} ;
do
    ping -c 2 $ip &> /dev/null ;
    if [ $? -eq 0 ] ;
    then
        echo $ip is alive
    fi
done

