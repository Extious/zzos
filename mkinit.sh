#!/bin/bash

lpyos=${1:-lpyos}
rootfs=ubuntu-focal-oci-amd64-root.tar.gz
rm -rf $lpyos

[ -e $rootfs ] || wget https://partner-images.canonical.com/oci/focal/current/ubuntu-focal-oci-amd64-root.tar.gz
if [ -d $lpyos.origin ]
then
    cp -r $lpyos.origin $lpyos
else
    mkdir -p $lpyos
    tar xzf $rootfs -C $lpyos

    mount --bind /dev $lpyos/dev
    mount --bind /run $lpyos/run
    cp chroot_config.sh $lpyos
    chroot $lpyos bash chroot_config.sh
    rm $lpyos/chroot_config.sh
    umount $lpyos/dev
    umount $lpyos/run

    cp -r $lpyos $lpyos.origin
fi

sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/g' $lpyos/etc/ssh/sshd_config
sed -i 's/X11Forwarding yes/X11Forwarding no/g' $lpyos/etc/ssh/sshd_config
sed -i 's/Subsystem/# Subsystem/g' $lpyos/etc/ssh/sshd_config
sed -i 's/#DNS=/DNS=114.114.114.114/g' $lpyos/etc/systemd/resolved.conf
sed -i 's/#NTP=/NTP=ntp.aliyun.com/g' $lpyos/etc/systemd/timesyncd.conf
echo 'LANG=C.UTF-8' > $lpyos/etc/default/locale
echo 'kernel.printk = 1 4 1 7' >> $lpyos/etc/sysctl.conf
cat << EOF > $lpyos/etc/systemd/network/20-wired.network
[Match]
Name=e*

[Network]
DHCP=yes
EOF

cat << EOF > $lpyos/etc/os-release
NAME=lpyOS
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="lpyOS"
VERSION_ID="1.0"
EOF

rm $lpyos/etc/update-motd.d/*
cat << EOF > $lpyos/etc/profile.d/lpyos-login.sh
echo -e "\033[1;33m
 ██╗      ██████╗  ██╗   ██╗  █████╗  ███████╗
 ██║      ██╔══██╗ ╚██╗ ██╔╝ ██╔══██╗ ██╔════╝
 ██║      ██████╔╝   ╚██╔╝   ██║  ██║ ███████╗
 ██║      ██╔═══╝     ██║    ██║  ██║ ╚════██║
 ███████╗ ██║         ██║    ╚█████╔╝ ███████║
 ╚══════╝ ╚═╝         ╚═╝     ╚════╝  ╚══════╝
                  by Liu Pengyu Seedclass 2018\033[0m"

echo "Kernel Version:"
uname -srmo
EOF

find $lpyos -name '*apt*' | tac | xargs rm -rf
find $lpyos -name '*libicu*' | tac | xargs rm -rf
find $lpyos -name '*gconv*' | tac | xargs rm -rf
find $lpyos -name '*dpkg*' | tac | xargs rm -rf
find $lpyos -name '*debconf*' | tac | xargs rm -rf
find $lpyos -name '*X11*' | tac | xargs rm -rf
find $lpyos -name '*sftp*' | tac | xargs rm -rf
find $lpyos -name '*pydoc*' | tac | xargs rm -rf
find $lpyos -name '*pdb*' | tac | xargs rm -rf
# find $lpyos -name '*freedesktop*' | tac | xargs rm -rf

# find $lpyos -name '*perl*' | tac | xargs rm -rf
# find $lpyos -name '*.pl' | tac | xargs rm -rf
# find $lpyos -name '*dash*' | tac | xargs rm -rf
# find $lpyos -name 'file' | tac | xargs rm -rf
# rm $lpyos/usr/bin/{systemd-analyze,openssl,wget,gpgv,ssh-keyscan,ssh-add,ssh-agent,localedef,diff,install,man}
# rm $lpyos/usr/bin/{mawk,vdir,dir,top,sort,lsblk,partx,gzip,date,factor,sha*,tic}
# rm -rf $lpyos/lib/python3.8/{test,unittest,email,http,multiprocessing,html,doctest.py,urllib}

rm $lpyos/usr/bin/systemd-analyze

find $lpyos -name '*python*' | tac | xargs rm -rf
find $lpyos -name '*py*3*' | tac | xargs rm -rf
find $lpyos -name '*.py' | tac | xargs rm -rf
rm -rf $lpyos/usr/share/pyshared
find $lpyos -name '*networkd-dispatcher*' | tac | xargs rm -rf

# find $lpyos -name '*terminfo*' | tac | xargs rm -rf # could not run 'clear' if deleted


rm -rf $lpyos/usr/share/doc
