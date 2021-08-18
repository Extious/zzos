#!/bin/bash

bash mkker.sh
bash mkinit.sh

cd lpyos
find . | cpio -H newc -o | xz -9 --check=crc32 > $OLDPWD/initrd.xz
cd -