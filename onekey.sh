#!/bin/bash

lpyos=lpyos
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

    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/g' $lpyos/etc/ssh/sshd_config
    sed -i 's/X11Forwarding yes/X11Forwarding no/g' $lpyos/etc/ssh/sshd_config
    sed -i 's/Subsystem/# Subsystem/g' $lpyos/etc/ssh/sshd_config
    cp -r $lpyos $lpyos.origin
fi

find $lpyos -name '*apt*' | tac | xargs rm -rf
find $lpyos -name '*libicu*' | tac | xargs rm -rf
find $lpyos -name '*gconv*' | tac | xargs rm -rf
find $lpyos -name '*dpkg*' | tac | xargs rm -rf
find $lpyos -name '*debconf*' | tac | xargs rm -rf
find $lpyos -name '*python*' | tac | xargs rm -rf
find $lpyos -name '*networkd-dispatcher*' | tac | xargs rm -rf
find $lpyos -name '*X11*' | tac | xargs rm -rf
# find $lpyos -name '*terminfo*' | tac | xargs rm -rf

rm -rf $lpyos/usr/share/doc