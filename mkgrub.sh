#!/bin/bash

device=${1:-/dev/sdb}
kernel_path=${2:-.}
os_name=${os_name:-zzos}
EFI_path=${EFI_path:-grub-core}

if ! [ -d grub-core ]; then
    rm -rf grub
    git clone git://git.savannah.gnu.org/grub.git
    cd grub
    ./bootstrap
    mkdir EFI64
    cd EFI64
    ../configure --target=x86_64 --with-platform=efi && make -j64
    cd ../..
    cp -r grub/EFI64/grub-core .
fi

dd if=/dev/zero of=$device bs=1b count=2048
cat <<EOF | fdisk $device
g
n


+256M
t
1
w

EOF
mkfs.fat -F32 ${device}1
umount /mnt
mount ${device}1 /mnt
grub-install -d $EFI_path --force --removable --no-floppy --target=x86_64-efi --boot-directory=/mnt/boot --efi-directory=/mnt
cat <<EOF > /mnt/boot/grub/grub.cfg
set timeout=3
set default=0
insmod all_video
loadfont unicode
terminal_output gfxterm
menuentry "$os_name" {
 linux /boot/bzImage
 initrd /boot/initrd.xz
}
EOF
scp $kernel_path/{bzImage,initrd.xz} /mnt/boot/
umount /mnt