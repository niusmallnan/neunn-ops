#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © neunn.com 
# Date  : 2014-05-30  
# Author: niusmallnan
# Email : <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.

"""

"""
import paramiko
import threading
import argparse
from subprocess import call
from conf import get_ip_list 

def ssh(ip, username, passwd, cmd=[], port=22):
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ip, port, username, passwd, timeout=5)
        for m in cmd:
            stdin, stdout, stderr = ssh.exec_command(m)
            #stdin.write("Y")   #简单交互，输入 ‘Y’ 
            #out = stdout.readlines()
            #屏幕输出
            #for o in out:
            #    print o,
        print '%s : OK'%(ip)
        ssh.close()
    except:
        print '%s\t server power off \n'%(ip)

def safe_shutdown(server_list, username, passwd):
    cmd = ['sudo shutdown -h now']
    for ip in server_list:
        td = threading.Thread(target=ssh, args=(ip, username, passwd, cmd))
        td.start()

def ipmi_power(server_list, action='-s'):
    for ip in server_list:
	#ipmipower -h $1 -u administrator -p "Neunn@)"\!"$" --driver-type=LAN_2_0 $2
	call(['ipmipower', '-h', ip, '-u', 'administrator', '-p', 'Neunn@)!$', '--driver-type=LAN_2_0',
			action])

      
parser = argparse.ArgumentParser(description='这是一个运维脚本程序')
parser.add_argument('-on', action='append', default=[], dest='power_on', help='机器批量下电')
parser.add_argument('-off', action='append', default=[], dest='power_off', help='机器批量上电')
parser.add_argument('-check', action='append' , default=[], dest='power_check', help='检测机器电影状态')


if __name__=='__main__':
    
    args = parser.parse_args()
    power_on = args.power_on
    power_off = args.power_off
    power_check = args.power_check
    
    if power_off:
        #get_ip_list('ip.cfg', power_on)
        safe_shutdown(get_ip_list('ip.cfg', power_off), 'ubuntu', '')
    if power_on:
        #print get_ip_list('ipmi.cfg', power_off)
        ipmi_power(get_ip_list('ipmi.cfg', power_on), '-n')
    
    if power_check:
        #print get_ip_list('ipmi.cfg', power_check)
        ipmi_power(get_ip_list('ipmi.cfg', power_check))
