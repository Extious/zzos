#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-lpyos}
feature=${2:-iwlwifi}

kernel_url=$(curl -s https://www.kernel.org/ | grep -Pzo "latest_link.*\n.*" | grep -a href | awk -F \" '{print $2}')
kernel_fn=${kernel_url##*/}
kernel_dir=${kernel_fn%.tar*}

if ! [ -e $kernel_fn ]; then
    echo Downloading $kernel_url
    wget $kernel_url
    rm -rf $kernel_dir
fi
[ -d $kernel_dir ] || tar xJf $kernel_fn
cp config.$feature $kernel_dir/.config
sed -i "s/os_name_placeholder/$os_name/g" $kernel_dir/.config
cd $kernel_dir
make olddefconfig
make -j64
cd -
cp $kernel_dir/arch/x86/boot/bzImage .
