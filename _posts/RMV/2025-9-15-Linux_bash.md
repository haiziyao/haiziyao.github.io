---
layout:     post
title:      "Linux and bash"
subtitle:   " \"How to use bash\""
date:       2025-09-15 08:00:00
author:     "Hzy"
header-img: "img/post-linux_bash.jpg"
catalog: true
tags:
    - Linux 
---

**前提说明：这篇文章很长，请有耐心**


####  1. <a name=''></a>文件
##### 文件目录
``` bash
pwd    #当前目录
ls     #列出文件夹
cd ~    #回到家目录
cd ..   #回到上一级目录
mkdir [-p]  #创建[多级]目录
#上面这句话解释一下，就是带-p就是多级目录，不带就是一级。下面会有很多类似写法
rmdir #删除空目录
rm -rf  #删除当前目录下的所有
rm -rf mydir #删除mydir里的所有
touch myfile #创建一个文件

cp myfilepath newfilepath #文件拷贝
cp -r 源目录/文件 目标地址

rm filename #删除文件
rm -f #跳过确定环节，直接删除
rm -r #递归
rm -rf 

mv oldfilename newfilename
mv oldfilepath newfilepath

cat filename #查看文件（仅仅只是查看）
cat -n filename  #显示行号
cat -n more   #翻页产看

more filename #查看文件
more的操作：
空格: 向下翻页
Enter: 向上翻页
q: 退出more
Ctrl+F: 向下滚动一屏
Ctrl+B: 返回上一屏
=: 输出当前行号
:f  : 输出当前文件名和行号

less filename #动态加载机制
pagedown键  
pageup键
q    退出
/字符  向下查找 n向下  N向上
?字符  向上查找 n向上  N向下 

echo "文字"  #输出语句
echo $PATH  #输出环境变量

head filename #默认查看前10行
head -n 5 filename #默认查看前5行

tail filename #查看后10行
tail -n 5 filename 
tail -f filename #实时监控文件变化

> #覆盖
>> #追加

history  #查看执行过的命令
history 10   #用编号查询
!387   #执行387编号代码

```

##### 文件压缩
``` bash
gzip filename
gunzip filename.gzip

zip filename 
unzip filename.zip

tar [-cvfzx] file.tar.gz  file1 file2
-c  产生.tar打包文件
-v 显示详细信息
-f 指定压缩后的文件名
-z 打包同时压缩
-x 解包
tar -zcvf c.tar.gz /a.txt /b.txt
tar -zxvf c.tar.gz /filepath
```
##### 搜索查找
``` bash
find [搜索范围] [选项]
find /home -name hellp.txt
find /opt -user nobody
find /home -size +200M

updatedb #更新索引数据库
locate filename #定位文件，一定要先执行前面的updatedb

which ls #查看ls指令在哪里

grep [-ni] content filename
-i #忽略大小写
-n #显示行号
```

####  2. <a name='-1'></a>其他指令
##### 帮助
``` bash
man ls #请那个男人帮忙ls命令怎么用
help
```
##### 时间日期
``` bash
date #显示当前时间
date +%Y  #年份
date +%m  #月份
date +%d  #显示当前哪一天
date "+%Y-%m-%d %H:%M:%S"
date -s "2020-11-03 20:13:23"

cal [选项]  #不加选项，直接显示本月日历
cal 2026  显示2026年日历
```

####  3. <a name='-1'></a>用户管理
``` bash
useradd -d useraddress myusername
useradd username 
passwd username #chage pwd
userdel username #删除用户，但是保留家目录
userdel -r username #全删除 
id username #查询用户信息
whoami #查看我是谁
who am i #详细信息
useradd -g username groupname #不给groupname，自动创建一个与用户名相同的组名
usremod -g groupname username #给用户改组名
#user存储：/etc/passwd
#group存储：/etc/group
#口令配置文件 /etc/shadow

init [0123456]  #切换运行级别
systemctl get-default #默认是graphical.target 就是级别5
systemctl set-default mult-user.target  #运行级别3

# 如何找回root密码
* 重启后疯狂按 e
* 找到linux  ········· UTF-8 
* 在后面输入 init=/bin/sh
* 按ctrl+x进入单用户模式
* 输入mount -o remount,rw /
* 按下Enter
* 输入passwd并按下Enter
* 可以重置密码了
* 最后一行输入 touch /.autorelabel
* 最后输入 exec /sbin/init 
* 按下Enter耐心等待

su username #切换用户
chwon usernmae file #更改文件的owner

#ls -l 显示的文件信息的含义  
drwxr-xr-x. 2 root root 4096 3月  27 21:10 公共
#第0位：确定文件类型  l 链接  d 目录  c  字符设备,鼠标键盘    b 块设备，硬盘
#三位：该文件的所有者的权限
#三位：用户组所有的权限
#三位：其他用户所有的权限  
  #作用在文件
    #r 可以读取，查看
    #w 可以修改但不能删除(删除文件需要有对目录可以修改的权限)
    #x 可以被执行
  #作用在目录
    #r  可以ls
    #w  可以创建+删除文件，重命名目录
    #x  可以cd进入目
  # 可以用数字表示  r=4 w=2 x=1 
  
#第二部分 一个数字 
	#目录 表示目录下文件数
	#文件 表示文件软连接数量  
# 所有者
#所在组
#文件大小：显示文件字节数量   如果是文件夹，则显示4096
#文件修改日期

chmod u=rwx,g=rx,o=x  文件/目录
chmod o+x 文件/目录
chmod a-x 文件/目录  #给所有用户去掉执行的权限

chmod 751 文件/目录

chown newowner:newgroup 文件/目录
chown -R newowner:newgroup 目录wo

chgrp -R newgroup 目录/文件
```
####  4. <a name='-1'></a>磁盘分区
``` bash
lsblk #查看挂载情况
lsblk -f 
# sda    8:0    0   20G  0 disk 
# sda2   8:2    0   17G  0 part /
# sda3   8:3    0    2G  0 part [SWAP]
# sdb    8:16   0    1G  0 disk 
# sd 表示是scic硬盘 a表示这是第一块硬盘 第二块就是b 
# 后面的数字表示是 第几个分区

# 添加一块硬盘并永久挂载
#1.添加硬盘


#2.分区
fdisk /dev/sdb    
 n q w  一定要输入w再退出
#3.格式化
mkfs -t ext4 /dev/sdb1
#4.挂载
mount /dev/sdb1 /home/mydisk
#5.卸载
umount /dev/sdb1

#以上方法重启后挂载消失

#永久挂载
vim /etc/fstab
写进去就好了

df -h 
#查询磁盘情况
du -h #查询指定目录使用情况
-s 大小汇总  
-h 带计量单位
-a 含文件
--max-depth=1 子目录深度
-c 列出明细并汇总
du -hac --max-depth=1 /opt

ls -l /opt | grep "^-" | wc -l
ls -l /opt | grep "^d" | wc -l
ls -lR /opt | grep "^-" | wc -l
ls -lR /opt | grep "^d" | wc -l
```
####  5. <a name='-1'></a>进程与服务
``` bash
ps -ef | grep sshd

kill -[]  [进程号]
killall [名字]  #同时杀死所有子进程
#找到非法登录的用户的进程号
kill 进程号
#终止服务
kill sshd
#终止应用
kill gedit
#强制杀死
kill -9 进程号

pstree #进程树
pstree -p  #显示进程ID
pstree -u  #显示user

service 服务名 [start|stop|restart|reload|status]
服务存在 /etc/init.d 中
setup   # 查看所有服务

#运行级别服务
# /etc/initab
systemctl get-default


systemctl set-default multi-user.target  
systemctl set-default graphical.target  
init 数字 #直接切换运行级别

#列出服务和对应与运行级别下 自启动状态
chkconfig --list
#
chkconfig --level 3 network off
chkconfig --level 3 network on 

#systemctl  [start|stop|restart|status] 服务名
systemctl list-unit-files [ | grep 服务名]  #查看开机启动状态
systemctl enable 服务名 
systemctl diable 
systemctl is-enable

firewall-cmd --permanent --add-port=端口号/协议
firewall-cmd --permanent --remove-port=端口号/协议
#以上修改必须重新载入才能生效
firewall-cmd --reload
#查询指令
firewall-cmd --query-port=端口/协议

#动态监控管理
top 
top -d 秒数   #每隔几秒就更新一次状态
-i  #不显示闲置或者僵死进程
-p # 通过指定监控进程ID

#先top
#按键P  按照cpu使用率排序
#按键M  按照内存使用率排序
#按键N  按照PID排序
#q   退出top
#u   可以输入用户名
#k   可以杀死进程

netstat -an | more
ping 
```
####  6. <a name='-1'></a>任务调度
``` bash
# 定时任务的执行
crontab [-elr]  
# e 编辑    l 查询   r 删除当前用户的所有crontab
crond * * * * *  命令 
#第一个星号：一天中的第几分钟 0-59
#      一天中的第几个小时       0-23
#      一个月的第几天     1-31
#      一年中的第几个月   1-12
#       一周中的周几    0-7   0和7都表示周日
crond */1 * * * * ls -l /etc/ > /tmp/to.txt

# , 逗号表示不连续的时间
# - 表示连续的时间范围
# */n 表示每隔多久就执行一次
45 22 * * * 
*/10 4 * * 1-5

#示例
vim /home/my.sh   
date >> /home/mycal  
cal >> /home/mycal
chmod u+x /home/my.sh
crontab -e 
*/1 * * * * /home/my.sh


crontab -r #终止任务调度
crontab -l #列出当前有哪些任务调度
service crond restart 重启任务调度


```

####  7. <a name='-1'></a>网络
``` bash
vim /etc/sysconfig/network-scripts/ifcfg-ens33

fcfg-ens33 文件说明
DEVICE=eth0 #接口名（设备,网卡）
HWADDR=00:0C:2x:6x:0x:xx #MAC 地址
TYPE=Ethernet #网络类型（通常是 Ethemet）
UUID=926a57ba-92c6-4231-bacb-f27e5e6a9f44 #随机 id
#系统启动的时候网络接口是否有效（yes/no）
ONBOOT=yes
# IP 的配置方法[none|static|bootp|dhcp]（引导时不使用协议|静态分配 IP|BOOTP 协议|DHCP 协议）
BOOTPROTO=static
#IP 地址
IPADDR=192.168.200.130
#网关
GATEWAY=192.168.200.2
#域名解析器
DNS1=192.168.200.2

hostname 查看主机名字
/etc/hostname 修改

/etc/hosts  修改ip映射
```