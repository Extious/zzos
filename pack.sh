#!/bin/bash

lpyos=${1:-lpyos}
cd $lpyos
find . | cpio -H newc -o | xz -9 --check=crc32 > ../initrd.xz
cd -
