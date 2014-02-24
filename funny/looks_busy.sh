#! /bin/bash
#
# looks_busy.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


cat /dev/urandom | hexdump -C | grep "ca fe"


j=0;while true; do let j=$j+1; for i in $(seq 0 20 100); do echo $i;sleep 1; done | dialog --gauge "Install part $j : `sed $(perl -e "print int rand(99999)")"q;d" /usr/share/dict/words`" 6 40;done



