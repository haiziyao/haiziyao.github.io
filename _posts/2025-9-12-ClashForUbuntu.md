---
layout:     post
title:      "Clash For Ubuntu22.04"
subtitle:   " \"Hello World, Hello Blog\""
date:       2025-09-12 24:00:00
author:     "Hzy"
header-img: " "
catalog: true
tags:
    - Train
---
    本人也是属于不知道配置过多少次Ubuntu以及在Ubuntu上面配置Clash了
    主要步骤如下
[下载Clash并解压](#下载Clash并解压)  
[启动clash生产配置文件](#启动clash生产配置文件)  
[补充.config，加入节点](#补充.config，加入节点)  
[配置网络](#配置网络)  
[参考博客](https://www.macw.cc/articles/158)

### 下载Clash并解压
[clash下载地址](https://github.com/DustinWin/clash_singbox-tools/releases/tag/Clash-Premium)  

**注意**：务必要确定你的版本，例如我的unbuntu22.04为amd64架构

    这里其实存在着不少讲究，就是在unbuntu22.04中
    su root 是不被允许的
    所以，有的时候我们在移动文件，创建目录等等操作时
    一定要注意自己在干什么
    chmod +x 文件
    chmod -751 文件
    你一定要注意"who am i"
    不小心使用root权限sudo mkdir  
    你可能就一直发现报错“无写入权限”，十分懊恼
    
### 启动clash生产配置文件
``` bash 
#在解压完成之后，你会得到一个Crash什么玩意的东西
#无脑改名为clash 
mv Crash clash
#之后直接
./clash -v
#执行上面这个命令，你一定要知道当前目录在哪里！
```
### 补充.config，加入节点
### 配置网络