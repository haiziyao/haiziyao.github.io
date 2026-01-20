---
layout:     post
title:      "树莓派"
subtitle:   " \"速通树莓派\""
date:       20256-1-19 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Version
---


## 入门篇
### 简单认识Raspberry
* 4个`USB`
* `HDMI` 
* 有`SD卡`
### 型号
* `Raspberry Pi 1 Model B`
* `Raspberry Pi 1 Model B +`
* `Raspberry Pi 2 Model B`
* `Raspberry Pi 3 Model B`
    * 无线和蓝牙通信
* `Raspberry Pi 3 Model B+`
* `Raspberry Pi 4 Model B`
    * 4核 64位
    * 内存可选
    * `3.0 USB`\*2 ,`2.0 USB`\*2 
    * 2\*HDMI
    * 等等d 
* 还有A版本,属于B版本的阉割版本
* Zero版本， 相对于B版本性能并没有太大阉割，但售价跳楼价
### 选型
* 扔个图就够了
### 操作系统
* Raspberry Pi OS 
    * 兼容所有树莓派版本
* Ubuntu
 
### 下载安装
#### Imagre
#### 直接烧录

## 基础篇
### 硬件
* SD卡的插入永远是金属朝下，看到的是彩色的一面
### 问题
* 显示器不支持热插拔
* 电源: 
    * 功率不能低于5V/3A
* 正确关机：
    * 桌面
    * 终端
    
    ``` bash
    sudo poweroff
    sudo shutdown -h now #立即关机
    sudo shutdown -r now #立即重启
    sudo shutdown -h +2 #2分钟后关机
    ```
### 远程连接
* 新建一个`ssh`文件，便可打开ssh连接
* wife配置 `wpa_supplicant.conf` 便可连接wife

```
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="HZY"
    psk="12345678"
    priority=10
} 
```

* 远程桌面连接需要`xrdp`
    * `apt-get install`
* 打卡VNC服务器
    * `sudo raspi-config`
* 静态IP地址设置
    * `hostname -I` 就能查看ip地址
    * `sudo nano /etc/dhcpcd.conf`

    ``` bash
    interface wlan0
    static ip_address=你的ip地址/24
    static routers=你的默认网关
    static domain_name_servers=你的默认网关
    ```


* username: pi
* password: raspberry
### 文件传输
* 开机自启动VNCserver
    
    ``` bash
    sudo nano /etc/init.d/vncserver
        #!/bin/sh
    export USER='pi'

    eval cd ~$USER

    case "$1" in
        start)
            # 启动命令行，此处自定义分辨率、控制台号码或其它参数。
            su $USER -c '/usr/bin/vncserver -depth 24 -geometry 1600x900 :1'
            echo "Starting VNCServer for $USER "
            ;;
        stop)
            su $USER -c '/usr/bin/vncserver -kill :1'
            echo "VNCServer stopped"
            ;;
        *)
            echo "Usage: /etc/init.d/vncserver {start|stop}"
            exit 1
            ;;
    esac
    exit 0

    sudo chmod 755 /etc/init.d/vncserver
    sudo update-rc.d vncserver defaults
    ``` 
* FTP文件传输

* 树莓派内置有`py2` 和 `py3`
* `WiringPi`
    * pip install wiringpi
    * 如果报错

    ``` bash
    cd /tmp
    wget https://project-downloads.drogon.net/wiringpi-latest.deb
    sudo dpkg -i wiringpi-latest.deb
    ```
### 终端命令
懒得写
### 系统备份和还原
#### 分区
* root分区
    * ext4
    * 系统配置
* boot分区
    * Fat32
    * 系统启动
    * 驱动文件
#### 系统备份
懒得写了，这些操作不会用到，用到再学，这些命令肯定记不住

* 全卡备份
    * win32软件
    * SD Card Copier
    * 命令行
        * 
* 压缩备份

### GPIO
#### 编码
`gpio readall`
* 板载编码
    * `pinout`可以看到引脚的命令
* BCM编码
* WiringPi

``` bash
gpio -g mode 4 out  # 设置管脚为out模式，-g 表示BCM编码,没有-g表示wiringPi编码
gpio -g read 4  #read status
gpio -g write 4 1 # 高电平
gpio -g write 4 0
```
####  操控GPIO
* 命令行控制，过于复杂，不写了
* 编程语言
#### 串口通信(UART)
* 传输速度较慢
* 串口 
    * 硬件串口
    * mini串口
*  引脚8  TXD
*  引脚10 RXD
* 主串口
    * 引脚通讯
* 辅助串口 
    * 不能引脚通信
    * 默认分配给蓝牙 
* mini串口默认禁用

* `ls /dev -al`
* 把硬件串口设置为主串口
* `sudo apt-get install minicom`
* `minicom -D /dev/ttyAMA0 -b 9600`
* 推出需要`CTRL+A` `CTRL+Z` `X`