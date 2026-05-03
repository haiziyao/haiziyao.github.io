---
layout:     post
title:      "RedisInterview"
subtitle:   " \"redis面经你值得拥有\""
date:       2026-5-2 15:33:18
author:     "HZY"
header-img: ""
catalog: true
tags:
    - java
---

### Redis

* redis的处理过程，源码解析



## Redis 持久化

### RDB( redis database backup)



### AOF( append only file)


## 主从

``` bash
slaveof ip port
```

### 数据同步

* 主从第一次同步： **全量同步**
    * bgsave + repl_baklog

<img src="/img/2026-5-2-RedisInterview/20260502-173307.png" alt="20260502-173307.png" style="width:100%; height:auto;">

* 增量同步
    * 通过offset同步 repl_baklog
    * repl_baklog 是一个循环数组
    * offset差距过大，不可避免进行全量同步

<img src="/img/2026-5-2-RedisInterview/20260502-173820.png" alt="20260502-173820.png" style="width:100%; height:auto;">

* 优化方法
    * 无磁盘复制
    * redis单节点内存占用不要太大
    * 适当提高repl_baklog的大小, 尽快实现故障恢复
    * 限制slave的节点数量使用链式 

<img src="/img/2026-5-2-RedisInterview/20260502-174041.png" alt="20260502-174041.png" style="width:100%; height:auto;">


### 哨兵

**主节点挂了怎么办**

* Sentinel集群  
    * 监控
        * 心跳机制监测服务状态
        * 主观下线
        * 客观下线
    * 自动故障恢复
    * 通知

<img src="/img/2026-5-2-RedisInterview/20260502-174842.png" alt="20260502-174842.png" style="width:100%; height:auto;">

* 配置读写分离
    * yaml文件

    ``` yaml
        spring:
            redis:
                sentinel:
                    master: mymaster
                    nodes:
                        - 192.168.150.101:27001
                        - 192.168.150.101:27003
                        - 192.168.150.101:27002
    ```


    * 配置Bean

    ``` java
        LettuceClientConfigurationBuilderCustomizer类
    ```

<img src="/img/2026-5-2-RedisInterview/20260502-180453.png" alt="20260502-180453.png" style="width:100%; height:auto;">

## 分片集群

<img src="/img/2026-5-2-RedisInterview/20260502-180652.png" alt="20260502-180652.png" style="width:100%; height:auto;">

* 散列插槽
    * 数据不和节点绑定，数据和插槽绑定
    * 如何把相同数据放在同一个redis分片中
        * set {a}num aaa
        * 大括号里面为有效hash值


* 配置
    * cluster

        ``` yaml
        spring:
            redis:
                cluster:
                    nodes:
                        - 192.168.150.101:7001
                        - 192.168.150.101:7003
                        - 192.168.150.101:7002
         ```


## 多级缓存
     
 <img src="/img/2026-5-2-RedisInterview/20260502-183147.png" alt="20260502-183147.png" style="width:100%; height:auto;">

#### JVM进程缓存

* Caffeine 示例

<img src="/img/2026-5-2-RedisInterview/20260502-184126.png" alt="20260502-184126.png" style="width:100%; height:auto;">


#### 多级缓存

<img src="/img/2026-5-2-RedisInterview/20260502-184539.png" alt="20260502-184539.png" style="width:100%; height:auto;">

##### OpenResty

对于这部分，我们先不管了，等以后再好好学吧，过个眼瘾就行了


##### 缓存同步

* 数据同步策略
    * 设置有效期
        * 简单，方便
        * 时效性差，不一致问题严重
        * 更新频率低，一致性时效性要求低
    * 同步双写
        * 失效性强，一致性强
        * 代码侵入
        * 一致性，时效性要求高
    * 异步通知
        * 低耦合，同时通知多个缓存服务
        * 时效性一般，可能存在中间不一致状态
        * 

* Canal 异步通知
    * 监听 bin log 自动更新

<img src="/img/2026-5-2-RedisInterview/20260502-192845.png" alt="20260502-192845.png" style="width:100%; height:auto;">


## Redis最佳实践



## 原理篇

### 数据结构

#### SDS  简单动态字符串
 
* sdshdr8
    * len : u8 ，所以最长254
    * alloc
    * flags
    * buf[]  
* sdshdr16,32,64


#### IntSet
* intset
    * encoding
    * length
    * contents[]

<img src="/img/2026-5-2-RedisInterview/20260503-151016.png" alt="20260503-151016.png" style="width:100%; height:auto;">


#### Dict
* dictht
    * table
    * size
    * sizemask
    * used

<img src="/img/2026-5-2-RedisInterview/20260503-151600.png" alt="20260503-151600.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-151649.png" alt="20260503-151649.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-152056.png" alt="20260503-152056.png" style="width:100%; height:auto;">

#### ZipList

* zlbytes 
* zltail: 最后一个节点的偏移量
* zllen
* entry 
    * 长度不固定
    * pre_entry_len
        * 1个字节或者 5个字节
    * encoding
        * 1/2/5
    * content
        * 字符串/整数
* zlend 

<img src="/img/2026-5-2-RedisInterview/20260503-153414.png" alt="20260503-153414.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-153427.png" alt="20260503-153427.png" style="width:100%; height:auto;">

#### QuickList

<img src="/img/2026-5-2-RedisInterview/20260503-153706.png" alt="20260503-153706.png" style="width:100%; height:auto;">

#### SkipList

<img src="/img/2026-5-2-RedisInterview/20260503-154619.png" alt="20260503-154619.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-154716.png" alt="20260503-154716.png" style="width:100%; height:auto;">


#### RedisObject

<img src="/img/2026-5-2-RedisInterview/20260503-154928.png" alt="20260503-154928.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-155308.png" alt="20260503-155308.png" style="width:100%; height:auto;">







### 网络模型

#### 阻塞IO
* 等待数据阻塞
* 数据拷贝阻塞
#### 非阻塞IO
* 反复轮询
* 数据拷贝阻塞

#### IO多路复用

<img src="/img/2026-5-2-RedisInterview/20260503-162228.png" alt="20260503-162228.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-163238.png" alt="20260503-163238.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-163700.png" alt="20260503-163700.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-170524.png" alt="20260503-170524.png" style="width:100%; height:auto;">

#### 信号驱动IO

#### 异步IO


### Redis 网络模型

* Redis核心业务是单线程，整个Redis是多线程

<img src="/img/2026-5-2-RedisInterview/20260503-171355.png" alt="20260503-171355.png" style="width:100%; height:auto;">

<img src="/img/2026-5-2-RedisInterview/20260503-171407.png" alt="20260503-171407.png" style="width:100%; height:auto;">


## 场景应用

### 缓存

* Cache Aside
* Read Through
* Write Through
* Write Behind