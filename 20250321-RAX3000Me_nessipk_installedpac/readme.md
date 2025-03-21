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
