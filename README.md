<h1 align="center">本仓库为[RAX3000Me](https://github.com/Daniel-Hwang/RAX3000Me) 的第三方个人备份</h1>
<h1 align="center">第三方个人备份</h1>
欢迎支持一键三连，点颗星星~谢谢呢

***20250401重要更新：20250321-RAX3000Me_nessipk_installedpac文件夹中有必要的软件包（对应immortalwrt-23.05.3），用于玩家从非我提供的bin刷机包刷机，请使用软件包时注意！！！！！此页面中的ipk包是kernel=5.15.162版本的，相对应的factory和sysupgrade文件为0318版！！！***

***这些ipk包不支持任何factory.itb和sysupgrade.itb的openwrt刷机包！！！请对应kernel进行安装软件包***

***20250321重要更新：add new wonderful drivers and firmware for brigding eth2(RNDIS-CDC) to lan***

***20250319重要更新：ADD usbutils RNDIS USB CDC and so on for USB 3.0 network drivers and storage***

***file: RAX3000Me-250316-sysupgrade.bin for update.***

***20250318重要更新：20250314更新修正，修正window中telnet解密的前13个字符，去掉后再返回正确的mypassword，用于之后的生成加密配置文件。主要是对powershell文件进行修改***

RAX3000Me路由器开发与固件刷入详细教程

软件版本号：RAX3000Me-MTK.ZD.03
生产日期：20241111

**闪存型号FM25S01A**
复旦微FUDANmicro
![3051d795bd0c28685852e10b3dc4612](https://github.com/user-attachments/assets/4c03fd99-c6d7-4fcb-ae0f-7cc5963706c8)


一、准备工作
1.2025.3.13版本realese-v1.0.0,说明需要使用linux虚拟机来生成解Telnet文件，推荐使用Ubuntu虚拟机，确保OpenSSL版本大于3.0（支持aes-256-cbc -pbkdf2）。
这一步已经在2025.3.14版本上更新windows上安装openssl，如下文件
https://github.com/LzxkJ04/RAX3000Me/tree/main/20241111-RAX3000Me_Step12-TelnetUboot
![78acf361160eb14c6722ef95d386219](https://github.com/user-attachments/assets/d2a71ddd-bc49-4baf-a197-8eacc4500b57)

直接安装，下一步下一步下一步，全部默认安装finish完成，搞定！

2.下载所需文件：https://www.123912.com/s/20zrVv-fFewh  提取码: FR9a，或者直接下载[release-v1.0.0](https://github.com/LzxkJ04/RAX3000Me/releases/tag/release-v1.0.0)
补充支持windows的生成解密conf的bat和ps1文件在https://github.com/LzxkJ04/RAX3000Me/tree/main/20241111-RAX3000Me_Step12-TelnetUboot

二、生成加密配置文件

1.在Ubuntu终端输入自己的SN码，获取设备序列号（SN位于设备背面）：
SN=5D11210006XXXXX

2.在Ubuntu终端中依次输入以下命令生成密码：

mypassword=$(openssl passwd -1 -salt aV6dW8bD "$SN")

mypassword=$(eval "echo $mypassword")

echo $mypassword

3.下载Telnet解锁配置文件：

wget https://github.com/LzxkJ04/RAX3000Me/raw/refs/heads/release-v1.0.0/20241111-RAX3000Me_Step12-TelnetUboot/RAX3000M_XR30_cfg-telnet-20240117.conf

4.加密并导入配置文件：

openssl aes-256-cbc -pbkdf2 -k "$mypassword" -in RAX3000M_XR30_cfg-telnet-20240117.conf -out cfg_import_config_file_new.conf


20250314重要更新：此1-4步，在2025.3.14版本上，安装完windows的openssl后，直接点击generate_config.bat，输入SN码后，直接生成cfg_import_config_file_new.conf。


***20250321重要更新：add new wonderful drivers and firmware for brigding eth2(RNDIS-CDC) to lan***

将生成的cfg_import_config_file_new.conf文件上传到路由器后台的配置导入页面，重启完成Telnet解锁。有bug可以issus我

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

在浏览器中访问192.168.1.1，选择刷入20250318_RAX3000Me-HY-factory.bin固件，等待重启。

![9f8da7bd8a0c157bdebcfa92bfc8816](https://github.com/user-attachments/assets/196e4713-b667-4b98-b1e3-e1de16c8bf07)

（注意uboot页面中刷入factory.bin文件和openwrt页面中的升级sysupgrade.bin文件页面不同）

完成刷入并重启后，电脑改为自动获取IP，浏览器访问192.168.1.1(依照你所刷的固件和电脑IP网段而定)，在升级界面继续刷入20250318_RAX3000Me-HY-sysupgrade.bin固件。

至此，OpenWrt固件成功刷入RAX3000Me路由器。

**如果继续刷入RNDIS相关驱动，请参见文件夹20250321-RAX3000Me_nessipk_installedpac文件夹中readme**
![PixPin_2025-04-07_02-55-53](https://github.com/user-attachments/assets/4bb514d6-325d-47fc-8073-1745f2ebd2a3)


访问192.168.1.1开始愉快的immortal openwrt玩耍吧！

现在可以支持中兴F50，飞猫U20的type c转网口，网线连接RAX3000Me的WAN，跑满5G速度；或者使用RAX中继U20，也是稳定跑满，甚至比中兴飞猫的还要好一点点。
