---
layout:     post
title:      "RabbitMQ"
subtitle:   " \"一天学习RabbitMQ\""
date:       2026-1-21 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Java
---


### 引入
* 同步调用
* 异步调用
    * 组成
        * 消息发送者
        * 消息代理
        * 消息接收者
    * 优点
        * 接触耦合，拓展性好
        * 无需等待，性能好
        * 故障隔离
        * 缓存消息，流量削峰填谷
    * 缺点
        * 不能立刻得到调用结果，时效性差
        * 不确定下游业务执行是否成功
        * 业务安全依赖于Broker的可靠性
* MQ技术选型(MessageQueue)

| 对比项 | RabbitMQ | ActiveMQ | RocketMQ | Kafka |
|---|---|---|---|---|
| 公司/社区 | Rabbit | Apache | 阿里 | Apache |
| 开发语言 | Erlang | Java | Java | Scala & Java |
| 协议支持 | AMQP、XMPP、SMTP、STOMP | OpenWire、STOMP、REST、XMPP、AMQP | 自定义协议 | 自定义协议 |
| 可用性 | 高 | 一般 | 高 | 高 |
| 单机吞吐量 | 一般 | 差 | 高 | 非常高 |
| 消息延迟 | 微秒级 | 毫秒级 | 毫秒级 | 毫秒以内 |
| 消息可靠性 | 高 | 一般 | 高 | 一般 |


