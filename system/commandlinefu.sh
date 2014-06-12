#! /bin/bash
#
# commandlinefu.sh
# Copyright (C) 2014 zhangzb <zhangzb@neunn.com>
#
# Distributed under terms of the MIT license.
#
# 收集各种简洁牛掰的小脚本
#


#监控eth0上80端口的数据包
tcpdump -i eth0 port 80 -w -

#打包整个系统
tar czvf ./compute_node.tar.gz / --exclude=/proc/* --exclude=/sys/* --exclude=/run/* --exclude=/tmp/* --exclude=/etc/udev/rules.d/70-persistent-net.rules --exclude=/var/lib/nova/instances/* --exclude=/var/lib/neutron/*

