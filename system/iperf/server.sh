#! /bin/bash
#
# server.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#



DATE=`date '+%Y-%m-%d'`
nohup iperf -s >> $DATE.log 2>&1 &

