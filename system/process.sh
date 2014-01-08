#! /bin/bash
#
# process.sh
# Copyright (C) 2014 zhangzb <zhangzb@neunn.com>
#
# Distributed under terms of the MIT license.
#


usage()
{
    echo "add a process name"
}

if (($# == 0))
then
    usage
    exit
fi

PROCESS=$1
echo "PROCESS: $PROCESS"
echo "old pid:";ps aux | grep $PROCESS | grep -v 'grep' | awk '{print $2}'
ps aux | grep $PROCESS | grep -v 'grep' | awk '{print $2}' | xargs kill -s 9  


