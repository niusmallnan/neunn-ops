#! /bin/bash
#
# nova_iscsi.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#

usage()
{
    echo "need a param for OceanStor Controller IP"
    echo "ex: ./nova_iscsi.sh 172.26.0.1"
}

if [ $# != 1 ]; then
    usage
    exit
fi

IQN=`iscsiadm --mode discovery --type sendtargets --portal $1 | awk {'print $2'}` 
echo "IQN is ${IQN}"

if [ -z "${IQN}" ]; then
    echo "fail to get IQN"
    exit 0
fi

iscsiadm -m node -T ${IQN} -l

fdisk -l

echo "set automatic"
iscsiadm -m node -T ${IQN} --op update -n node.startup -v automatic

echo "format lun"
read -p "whick disk u chose (default: sdb): " FORMAT_DISK
FORMAT_DISK=${FORMAT_DISK:-sdb}
mkfs.ext4 /dev/${FORMAT_DISK}

echo "mount & set auth"
mount /dev/${FORMAT_DISK} /var/lib/nova/instances/
chown -R nova:nova /var/lib/nova/instances/
rm -rf /var/lib/nova/instances/lost+found/

UUID=`ls -l /dev/disk/by-uuid | grep ${FORMAT_DISK} | awk {'print $9'}`
if [ -z "${UUID}" ]; then
    echo "fail to get UUID"
    exit 0
fi
echo "write fstab UUID is ${UUID}" 
echo "UUID=${UUID} /var/lib/nova/instances ext4 defaults,nobootwait 0 0" >> /etc/fstab 

echo "write rc.local"
sed -i 's/exit 0//g' /etc/rc.local
echo "mount -a" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local

restart nova-compute


fdisk -l
df -hl


