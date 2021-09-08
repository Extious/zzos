#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-lpyos}

cat << EOF > $os_name/etc/os-release
NAME=lpyOS
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="lpyOS"
VERSION_ID="1.0"
EOF

rm $os_name/etc/update-motd.d/*
cat << EOF > $os_name/etc/profile.d/lpyos-login.sh
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

echo "lpyOS" > $os_name/etc/hostname

cat <<EOF > $os_name/root/mnt_test.sh
#!/bin/bash

device=\${1:-/dev/sdc}

for ((i=1;i<=10;i++))
do
    echo Testing \$device\$i
    mount \$device\$i /mnt
    cat /mnt/info.txt
    umount /mnt
done
EOF
chmod +x $os_name/root/mnt_test.sh