#! /bin/bash
#
# test_lbass.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


while :
do
    curl 192.168.1.205:8080 -D - -o /dev/zero -s
done
