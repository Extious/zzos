#!/bin/bash

version=${1:-5.13.11}
kernelxz=linux-$version.tar.xz
kerneldir=linux-$version

[ -e $kernelxz ] || wget https://cdn.kernel.org/pub/linux/kernel/v5.x/$kernelxz
tar xJf $kernelxz
cp .config $kerneldir/
cd $kerneldir
make -j64
cd -
cp $kerneldir/arch/x86/boot/bzImage .