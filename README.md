"# RAX3000Me" 
软件版本号：RAX3000Me-MTK.ZD.03
生产日期20241111

在linux虚拟机上运行
1.加密配置文件在ubuntu（虚拟机就成）中用ssh生成（要求openssl>3.0版本，需要有aes-256-cbc -pbkdf2）。上传uboot到rax3000me用的是离线方式。
ssh到linux下输入
RAX3000Me序列号SN在设备背面可以找到（输入你自己设备的SN），注意大小写，复制粘贴到ssh命令行里
SN=5D11210006XXXXX

2.以下三行连选，复制粘贴到ssh命令行里
mypassword=$(openssl passwd -1 -salt aV6dW8bD "$SN")
mypassword=$(eval "echo $mypassword")
echo $mypassword

3.下载配置文件的github地址
wget https://github.com/Daniel-Hwang/RAX3000Me/tree/main/20241111-RAX3000Me_Step12-TelnetUboot/RAX3000M_XR30_cfg-telnet-20240117.conf
如果上面地址不行用下面国内地址
wget https://github.akams.cn/https:// ... elnet-20240117.conf
4. 加密配置文件，然后上传导入到路由器，等待重启后即可解锁Telnet
openssl aes-256-cbc -pbkdf2 -k "$mypassword" -in RAX3000M_XR30_cfg-telnet-20240117.conf -out cfg_import_config_file_new.conf
5.将cfg_import_config_file_new.conf从linux主机里下载出来，上传到RAX3000Me路由器后台的配置文件更新导入里

接下来就是在电脑主机上telnet路由器了
6.此时用telnet方式应该可以登录到RAX3000Me的IP地址上，正常应该是192.168.10.1，没有用户名密码
7.用压缩包里的HTTP_File_Server.exe建立一个http服务（这里请使用windows 8兼容模式，这个软件兼容win10和11差），把下载好的mt7981_cmcc_rax3000m-fip-fixed-parts.bin文件拖入到http软件里，并且开启http file server。
8.在telnet窗口里使用下面命令把mt7981_cmcc_rax3000m-fip-fixed-parts.bin下载到RAX3000Me的/tmp目录里
wget -P /tmp http://192.168.10.2/mt7981_cmcc_rax3000m-fip-fixed-parts.bin
9.烧写Uboot
mtd write /tmp/mt7981_cmcc_rax3000m-fip-fixed-parts.bin FIP

此之后，RAX3000Me的地址变成192.168.1.x了
接下来才是正式的刷机openwrt immortal
11. 设置电脑的静态IP地址设置为192.168.1.2，子网掩码为255.255.255.0，网关为192.168.1.1
12. 用曲别针或者取卡针顶住RESET按钮，插上电源后大约10秒，指示灯变蓝色后松开按钮（有些RAX路由器是绿色，可能是硬件的问题），网线一头插电脑上，另一头插在路由器LAN口上
13. 浏览器输入192.168.1.1，选择20250313_RAX3000Me-factory.bin固件刷写等待重启
14. 电脑改为自动获取IP地址，浏览器输入192.168.5.1，在固件里用软件升级刷写20250313_RAX3000Me-sysupgrade.bin固件
