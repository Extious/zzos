# 种子班Linux课设

### 实验目的
- 完成最新版本Linux kernel内核及其配套的 RAMDisk文件系统定制工作

### 实验要求
- 内核文件\<4M
- initrd.img\<24M

### 功能要求
- 通过U盘加载kernel和img启动进行验证
- 支持多用户登录（console界面和ssh网络方式）
- 系统支持通过ssh方式访问其他机器
- 可挂载U盘
- 可访问机器上的windows分区（ntfs-3g fs支持）

### usage
- 定制或删除custom.sh
- 生成bzImage, initrd.xz（可以在服务器上完成）
```bash
./onekey.sh [os_name]
```
- 制作启动盘（可以插U盘的主机）
```bash
./mkgrub.sh /dev/sdx [kernel_path]
```

### 文件功能
|文件|功能|
|-|-|
|rtl_nic|网卡固件|
|.config|linux内核配置文件|
|chroot_config|chroot模式配置initrd，安装systemd，ssh等|
|custom.sh|个性化设置（可选）|
|mkgrub.sh|制作启动盘|
|mkinit.sh|制作initrd|
|mkker.sh|编译内核|
|onekey.sh|一键脚本|
|pack.sh|打包initrd|
|patch.sh|文件补丁（固件等）|
|prepare.sh|安装依赖|