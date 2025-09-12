---
layout:     post
title:      "Clash For Ubuntu22.04"
subtitle:   " \"How to use Clash In Ubuntu22.04\""
date:       2025-09-12 24:00:00
author:     "Hzy"
header-img: " "
catalog: true
tags:
    - Ubuntu
---
    本人也是属于不知道配置过多少次Ubuntu以及在 
    Ubuntu上面配置Clash了
    主要步骤如下(以下仅为注意事项标注以及操作大纲，具体步骤见参考博客)
    
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
#在解压完成之后，你会得到一个CrashCore的东西
#无脑改名为clash 
mv CrashCore clash
#之后直接
./clash -v
#执行上面这个命令，你一定要知道当前目录在哪里！
```
### 补充.config，加入节点
``` bash
#找到我们clash的config.yaml文件
#一般可能自动生成在clash目录或者~/.comfig/clash内
cd ~/.config/clash
wget -O config.yaml 这里放置你的机场链接
#好了，现在启动clash试试吧
#切换到clash安装目录
./clash
#如果有节点信息info，那么你就已经配置成功了
``` 
### 配置网络
#### 端口被占用
 clash中，默认网关是127.0.0.1:7890  
如果你下载了其他东西，7890端口被占用了，你就需要在config文件里面更改端口号。（这里我不再写了）  
#### 网络代理设置
现在我们只需要到网络设置里面，更改网络代理就好了  
我们clash走的协议为http，https，Socket5   
所以把这三个的代理ip改为127.0.0.1，监听端口为7890  
#### 打开clash面板
clash面板默认端口为9090  
也就是127.0.0.1:9090  
也有内网域名http://clash.razord.top/
#### 测试
OK,快打开你的Google试试吧！