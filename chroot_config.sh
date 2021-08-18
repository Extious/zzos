#!/bin/bash

mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C

echo "nameserver 114.114.114.114" > /etc/resolv.conf
echo "lpyOS" > /etc/hostname
echo "root:root" | chpasswd

apt-get update
echo -e "6\n70\n" | apt-get install -y openssh-server
apt-get install -y pciutils iproute2

ln -s /lib/systemd/systemd /init
ln -s /lib/systemd/system/systemd-networkd.service /etc/systemd/system/

apt-get clean
rm -rf /tmp/* ~/.bash_history
umount /proc
umount /sys
umount /dev/pts
export HISTSIZE=0
