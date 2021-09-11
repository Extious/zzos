#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-lpyos}
feature=${2:-iwlwifi}

rootfs=ubuntu-focal-oci-amd64-root.tar.gz
rm -rf $os_name

if [ -e $rootfs ]
then
    rm -f SHA256SUMS
    wget https://partner-images.canonical.com/oci/focal/current/SHA256SUMS
    sha256sum -c SHA256SUMS --ignore-missing --strict --quiet
    [ $? -eq 0 ] || rm -rf $rootfs $os_name $os_name.origin
fi
[ -e $rootfs ] || wget https://partner-images.canonical.com/oci/focal/current/$rootfs
if [ -d $os_name.origin ]
then
    rm -rf $os_name
    cp -r $os_name.origin $os_name
else
    mkdir -p $os_name
    tar xzf $rootfs -C $os_name

    mount --bind /dev $os_name/dev
    mount --bind /run $os_name/run
    cp chroot_config.sh $os_name
    chroot $os_name bash chroot_config.sh $feature
    rm $os_name/chroot_config.sh
    umount $os_name/dev
    umount $os_name/run

    cp -r $os_name $os_name.origin
fi

sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/g' $os_name/etc/ssh/sshd_config
sed -i 's/X11Forwarding yes/X11Forwarding no/g' $os_name/etc/ssh/sshd_config
sed -i 's/Subsystem/# Subsystem/g' $os_name/etc/ssh/sshd_config
sed -i 's/#DNS=/DNS=114.114.114.114/g' $os_name/etc/systemd/resolved.conf
sed -i 's/#NTP=/NTP=ntp.aliyun.com/g' $os_name/etc/systemd/timesyncd.conf
echo 'LANG=C.UTF-8' > $os_name/etc/default/locale
echo 'kernel.printk = 1 4 1 7' >> $os_name/etc/sysctl.conf
cat << EOF > $os_name/etc/systemd/network/20-wired.network
[Match]
Name=e*

[Network]
DHCP=yes
EOF

find $os_name -name '*apt*' | tac | xargs rm -rf
find $os_name -name '*libicu*' | tac | xargs rm -rf
find $os_name -name '*gconv*' | tac | xargs rm -rf
find $os_name -name '*dpkg*' | tac | xargs rm -rf
find $os_name -name '*debconf*' | tac | xargs rm -rf
find $os_name -name '*X11*' | tac | xargs rm -rf
find $os_name -name '*sftp*' | tac | xargs rm -rf
find $os_name -name '*pydoc*' | tac | xargs rm -rf
find $os_name -name '*pdb*' | tac | xargs rm -rf
find $os_name -name '*freedesktop*' | tac | xargs rm -rf
find $os_name -name '*dash*' | tac | xargs rm -rf
find $os_name -name 'file' | tac | xargs rm -rf
find $os_name -name 'man' | tac | xargs rm -rf
find $os_name -name 'doc' | tac | xargs rm -rf

find $os_name -name '*python*' | tac | xargs rm -rf
find $os_name -name '*py*3*' | tac | xargs rm -rf
find $os_name -name '*.py' | tac | xargs rm -rf
rm -rf $os_name/usr/share/pyshared
find $os_name -name '*networkd-dispatcher*' | tac | xargs rm -rf

# find $os_name -name '*terminfo*' | tac | xargs rm -rf # could not run 'clear' if deleted

rm -rf rm $os_name/usr/bin/{gpgv,install,sha*,localedef,factor}


[ $feature == "btrfs" ] && rm $os_name/usr/bin/systemd-analyze $os_name/usr/sbin/iw
[ $feature == "iwlwifi" ] && find $os_name -name '*perl*' | tac | xargs rm -rf
[ $feature == "iwlwifi" ] && find $os_name -name '*.pl' | tac | xargs rm -rf