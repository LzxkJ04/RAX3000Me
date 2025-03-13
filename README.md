"# RAX3000Me" 
RAX3000Me路由器开发与固件刷入详细教程

软件版本号：RAX3000Me-MTK.ZD.03
生产日期：20241111

一、准备工作

1.需要使用linux虚拟机来生成解Telnet文件，推荐使用Ubuntu虚拟机，确保OpenSSL版本大于3.0（支持aes-256-cbc -pbkdf2）。

2.下载所需文件：https://www.123865.com/s/9JnLTd-18jhd?提取码:OI7L

二、生成加密配置文件

1.在Ubuntu终端输入自己的SN码，获取设备序列号（SN位于设备背面）：
SN=5D11210006XXXXX

2.在Ubuntu终端中依次输入以下命令生成密码：

mypassword=$(openssl passwd -1 -salt aV6dW8bD "$SN")

mypassword=$(eval "echo $mypassword")

echo $mypassword

3.下载Telnet解锁配置文件：

wget https://github.com/Daniel-Hwang/RAX3000Me/raw/refs/heads/release-v1.0.0/20241111-RAX3000Me_Step12-TelnetUboot/RAX3000M_XR30_cfg-telnet-20240117.conf

4.加密并导入配置文件：

openssl aes-256-cbc -pbkdf2 -k "$mypassword" -in RAX3000M_XR30_cfg-telnet-20240117.conf -out cfg_import_config_file_new.conf

将生成的cfg_import_config_file_new.conf文件上传到路由器后台的配置导入页面，重启完成Telnet解锁。

三、通过Telnet更新Uboot

使用网线连接路由器LAN口

Telnet登录路由器（默认IP地址192.168.10.1，无需账号密码）。

在Windows电脑中使用HTTP_File_Server.exe（Win8兼容模式），添加mt7981_cmcc_rax3000m-fip-fixed-parts.bin文件，并且开启http file server。

在Telnet终端下载Uboot文件至路由器/tmp文件夹下：

wget -P /tmp http://192.168.10.2/mt7981_cmcc_rax3000m-fip-fixed-parts.bin

烧录Uboot：

mtd write /tmp/mt7981_cmcc_rax3000m-fip-fixed-parts.bin FIP

完成后，路由器IP地址变为192.168.1.x段。

四、这才正式开始刷入OpenWrt固件

设置电脑静态IP为192.168.1.2

子网掩码255.255.255.0

网关192.168.1.1

用曲别针或者取卡针按住路由器RESET按钮，插电后约10秒，指示灯变色（蓝色或绿色，有些RAX路由器是绿色，可能是硬件的问题？）后松开。电脑网线连接路由器LAN口。

在浏览器中访问192.168.1.1，选择刷入20250313_RAX3000Me-factory.bin固件，等待重启。

完成刷入并重启后，电脑改为自动获取IP，浏览器访问192.168.5.1，在升级界面继续刷入20250313_RAX3000Me-sysupgrade.bin固件。

至此，OpenWrt固件成功刷入RAX3000Me路由器。

访问192.168.5.1开始愉快的immortal openwrt玩耍吧！

现在可以支持中兴F50，飞猫U20的type c转网口，网线连接RAX3000Me的WAN，跑满5G速度；或者使用RAX中继U20，也是稳定跑满，甚至比中兴飞猫的还要好一点点。
