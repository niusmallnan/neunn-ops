#! /bin/bash
#
# power.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


ipmipower -h $1 -u administrator -p "Neunn@)"\!"$" --driver-type=LAN_2_0 $2

