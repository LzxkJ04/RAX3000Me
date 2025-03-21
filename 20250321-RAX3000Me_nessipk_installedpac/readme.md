***20250322 ADD dependency kmod-mii first to install and then the kmod-usb-net -> kmod-usb-cdc-ether -> kmod-usb-net-rndis***

因为有依赖问题，首次安装时，如果不想给设备opkg update以及无法可能的翻墙修改清华或上交源，那么请使用本ipk库
***firstly*** 上传kmod-mii软件包并安装
![image](https://github.com/user-attachments/assets/20a14b87-9bf8-487f-9eb5-f9913a4ab1db)
***secondly*** 上传kmod-usb-net软件包并安装

***thirdly*** 上传kmod-usb-cdc-ether软件包并安装

***forthly*** 上传kmod-usb-net-rndis软件包,以及所有其他的包并安装

Finish！

**如果想用installed-packages.txt进行恢复所有安装，请按照如下：**
备份已安装包的列表
如果你想备份已安装包的列表（而不是具体的 .ipk 文件），可以导出已安装包的列表，方便以后重新安装。

恢复安装
在需要恢复时，可以使用以下命令批量安装：

cat installed-packages.txt | awk '{print $1}' | xargs opkg install


**使用 sysupgrade 恢复**
如果你想备份整个系统（包括所有已安装的包和配置），可以使用 sysupgrade 工具。

恢复备份
在需要恢复时，可以将 backup.tar.gz 文件上传到路由器，然后运行：

sysupgrade -r backup.tar.gz

**使用ipk安装包**
直接手动拖进WEB页面，软件包安装本目录下所有ipk
