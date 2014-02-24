#! /bin/bash
#
# route_for_mac.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


route -n delete -net 192.168.0.0/24 192.168.1.229
route -n delete -net 11.11.11.0/24 192.168.1.229
route -n delete -net 50.50.50.0/24 192.168.1.229
route -n delete -net 20.20.20.0/24 192.168.1.212
route -n delete -net 192.168.3.0/24 192.168.1.212

route -n add -net 192.168.0.0/24 192.168.1.229
route -n add -net 11.11.11.0/24 192.168.1.229
route -n add -net 50.50.50.0/24 192.168.1.229
route -n add -net 20.20.20.0/24 192.168.1.212
route -n add -net 192.168.3.0/24 192.168.1.212

