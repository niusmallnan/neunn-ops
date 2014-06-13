#! /bin/bash
#
# nova_compute_install.sh
# Copyright (C) 2014 niusmallnan <zhangzhibo521@gmail.com>
#
# Distributed under terms of the MIT license.
#


apt-get update
apt-get install qemu-kvm -y
apt-get install nova-compute-kvm python-guestfs -y
apt-get install python-mysqldb -y
dpkg-statoverride  --update --add root root 0644 /boot/vmlinuz-$(uname -r)

cat>>/etc/kernel/postinst.d/statoverride<<EOF
#!/bin/sh
version="\$1"
# passing the kernel version is required
[ -z "\${version}" ] && exit 0
dpkg-statoverride --update --add root root 0644 /boot/vmlinuz-\${version}
EOF

chmod +x /etc/kernel/postinst.d/statoverride

rm /var/lib/nova/nova.sqlite


