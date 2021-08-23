#!/bin/bash

kernel_url=$(curl -s https://www.kernel.org/ | grep -Pzo "latest_link.*\n.*$" | grep href | awk -F \" '{print $2}')
kernel_fn=${kernel_url##*/}
kernel_dir=${kernel_fn%.tar*}

if ! [ -e $kernel_fn ]; then
    echo Downloading $kernel_url
    wget $kernel_url
    rm -rf $kernel_dir
fi
[ -d $kernel_dir ] || tar xJf $kernel_fn
cp .config $kernel_dir/
cd $kernel_dir
make -j64
cd -
cp $kernel_dir/arch/x86/boot/bzImage .
