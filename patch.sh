#!/bin/bash

lpyos=${1:-lpyos}
mkdir -p $lpyos/lib/firmware/
cp -r rtl_nic $lpyos/lib/firmware/

cat << EOF > $lpyos/bin/ifup
#!/bin/bash

device=\${1:-eth0}

ip link set \$device up
ip addr add 192.168.10.99/25 dev \$device
ip route add default via 192.168.10.1
EOF
chmod +x $lpyos/bin/ifup

cat <<EOF > $lpyos/root/mnt_test.sh
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
chmod +x $lpyos/root/mnt_test.sh
