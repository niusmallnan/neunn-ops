#! /bin/bash
#
# route_for_mac.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


route -n delete -net 172.17.0.0/16 172.16.99.1
route -n delete -net 192.168.250.0/24 172.16.99.1
route -n delete -net 192.168.252.0/24 172.16.99.1

route -n add -net 172.17.0.0/16 172.16.99.1
route -n add -net 192.168.250.0/24 172.16.99.1
route -n delete -net 192.168.252.0/24 172.16.99.1

