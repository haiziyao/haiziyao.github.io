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

#### 文件
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

#### 其他指令
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

#### 用户管理
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

```
#### 磁盘分区
#### 进程与服务
#### 任务调度
#### 网络