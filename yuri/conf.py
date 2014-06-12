#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © neunn.com 
# Date  : 2014-06-12  
# Author: niusmallnan
# Email : <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.

"""

"""
import os
import ConfigParser

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

config = None 

def configure(config_file):
    global config
    config = ConfigParser.ConfigParser()
    config.read(os.path.join(BASE_DIR, config_file))


def get_ip_list(config_file, sections):
    configure(config_file)
    result = []
    for section in sections:
        for item in config.items(section):
            result.append(item[1])
    return result
