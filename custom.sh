#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-zzos}

cat << EOF > $os_name/etc/os-release
NAME=ZZOS
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="ZZOS"
VERSION_ID="1.0"
EOF

rm $os_name/etc/update-motd.d/*
cat << EOF > $os_name/etc/profile.d/zzos-login.sh
echo -e "\033[1;33m
 _____  _____   ___    ____  
|__  / |__  /  / _ \  / ___| 
  / /    / /  | | | | \___ \ 
 / /_   / /_  | |_| |  ___) |
/____| /____|  \___/  |____/ 
                             
                  by Zhan Zhao Seedclass 2021\033[0m"
echo "Kernel Version:"
uname -srmo
EOF

echo "ZZOS" > $os_name/etc/hostname

cat <<EOF > $os_name/root/mnt_test.sh
#!/bin/bash

device=\${1:-/dev/sda}

for ((i=1;i<=10;i++))
do
    echo Testing \$device\$i
    mount \$device\$i /mnt
    cat /mnt/info.txt
    umount /mnt
done
EOF
chmod +x $os_name/root/mnt_test.sh