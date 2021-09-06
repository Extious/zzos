#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-lpyos}
mkdir -p $os_name/lib/firmware/
cp -r rtl_nic $os_name/lib/firmware/

cat << EOF > $os_name/bin/ifup
#!/bin/bash

device=\${1:-eth0}

ip link set \$device up
EOF
chmod +x $os_name/bin/ifup

cat << EOF > $os_name/bin/ipsetup
#!/bin/bash

device=\${1:-eth0}
ipmask=\${2:-192.168.10.97/25}
gw=\${3:-192.168.10.1}

ip addr add \$ipmask dev \$device
ip route add default via \$gw
EOF
chmod +x $os_name/bin/ipsetup

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
