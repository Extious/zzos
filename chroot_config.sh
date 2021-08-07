#!/bin/bash

mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C

echo "nameserver 114.114.114.114" > /etc/resolv.conf
echo "root:root" | chpasswd

apt-get update
echo -e "6\n70\n" | apt-get install -y openssh-server

ln -s /lib/systemd/systemd /init

apt-get clean
rm -rf /tmp/* ~/.bash_history
umount /proc
umount /sys
umount /dev/pts
export HISTSIZE=0