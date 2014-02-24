#! /bin/bash
#
# test_reg.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


FILTER_REG=".*refs #[1-9]\d*"
echo $1

if [[ "$1" =~ $FILTER_REG ]]; then
    echo "match...."
else
    echo "no match...."
fi



