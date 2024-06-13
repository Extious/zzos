os_name=${1:-zzos}
feature=${2:-iwlwifi}

# kernel_url=$(curl -s https://www.kernel.org/ | grep -Pzo "latest_link.*\n.*" | grep -a href | awk -F \" '{print $2}')
# kernel_fn=${kernel_url##*/}
# kernel_dir=${kernel_fn%.tar*}

# if ! [ -e $kernel_fn ]; then
#     echo Downloading $kernel_url
#     wget $kernel_url
#     rm -rf $kernel_dir
# fi
# [ -d $kernel_dir ] || tar xJf $kernel_fn
# cp config.$feature $kernel_dir/.config

kernel_dir=linux-6.9.4

# 编辑配置文件，去掉不必要的调试信息和选项
sed -i "s/os_name_placeholder/$os_name/g" $kernel_dir/.config
sed -i "s/CONFIG_DEBUG_KERNEL=y/# CONFIG_DEBUG_KERNEL is not set/g" $kernel_dir/.config
sed -i "s/CONFIG_DEBUG_INFO=y/# CONFIG_DEBUG_INFO is not set/g" $kernel_dir/.config
sed -i "s/CONFIG_DEBUG_INFO_DWARF4=y/# CONFIG_DEBUG_INFO_DWARF4 is not set/g" $kernel_dir/.config

cd $kernel_dir
make olddefconfig

# 开始内核配置的最小化过程
make menuconfig
# 在menuconfig界面，选择删去不必要的模块


# 编译内核
make -j8 bzImage

cd -
cp $kernel_dir/arch/x86/boot/bzImage .