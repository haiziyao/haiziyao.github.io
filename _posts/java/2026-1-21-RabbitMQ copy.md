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

#### Mq安装和基本介绍

* virtual-host: 虚拟主机
* publisher
* exchange
* queue
* consumer

<img src="/img/2026-1-21-RabbitMQ/20260125-174956.png" alt="20260125-174956.png" style="width:70%; height:auto;">

### 快速入门

#### AMQP
* Advanced Message Queuing Protocol:  是一种协议
* Spring AMQP: 使用协议的api规范
    * spring-rabbit

#### Work模型

<img src="/img/2026-1-21-RabbitMQ/20260125-194248.png" alt="20260125-194248.png" style="width:50%; height:auto;">

* 默认有一个比较有意思的机制
    * 轮询：也就是说50条消息，只看到了两个消费者，于是就平均分发了下去，丝毫不会考虑消费者的能力
    * `prefetch: 1`设置这个表示一次只能取一个，处理完再取下一个


#### 交换机
* Fanout: 广播
* Direct: 定向
* Topic: 话题

##### Fanout
所有人都能收到

``` java
@Test
void testSendFanout() {
    String exchangeName = "amq.fanout";
    String msg = "hello, everyone!";
    rabbitTemplate.convertAndSend(exchangeName, "", msg);
}
```

##### Direct
* 预定一个`BindingKey`
* 指定'RoutingKey'

``` java
@Test
void testSendTopic() {
    String exchangeName = "hmall.topic";
    String msg = "今天天气挺不错，我的心情的挺好的";
    rabbitTemplate.convertAndSend(exchangeName, "china.weather", msg); //通过指定RoutingKey
}
```

##### Topic
* `china.#`  
* `#.weather`

* `*`表示一个单词
* `#`表示0或多个单词

<img src="/img/2026-1-21-RabbitMQ/20260125-201318.png" alt="20260125-201318.png" style="width:50%; height:auto;">

#### 声明队列和交换机
* `Queue` `QueueBuilder`
* `Exchange` `ExchangeBuilder`
* `Binding` `BindingBuilder`

* 返回一个Bean的类就行

<img src="/img/2026-1-21-RabbitMQ/20260125-201632.png" alt="20260125-201632.png" style="width:50%; height:auto;">

``` java
@Configuration
public class FanoutConfiguration {
    @Bean
    public FanoutExchange fanoutExchange() {
        return new FanoutExchange("fanoutExchange");
    }
    @Bean
    public Queue fanoutQueue() {
        QueueBuilder.durable();  //这两种方式都可以new一个
        return new Queue("fanoutQueue");  //默认durable()持久化，即存储在磁盘
    }

    @Bean
    public Binding fanoutBinding(Queue fanoutQueue, FanoutExchange fanoutExchange) {
        //return BindingBuilder.bind(fanoutQueue()).to(fanoutExchange());
        return BindingBuilder.bind(fanoutQueue).to(fanoutExchange);
    }


```

#### 注解式声明

<img src="/img/2026-1-21-RabbitMQ/20260125-203624.png" alt="20260125-203624.png" style="width:50%; height:auto;">

``` java
@RabbitListener(bindings = @QueueBinding(
        value = @Queue(name = "direct.queue1", durable = "true"),
        exchange = @Exchange(name = "hzy.direct",type = ExchangeTypes.DIRECT),
        key = {"red","blue"}
))
```

#### 类型
* `ConvertAndSend()`这个方法都说出来了，对于Object, 底层肯定是jdk序列化然后再发给mq
* jdk自己的底层的序列化工具太丑了，还有安全漏洞，所以我们选择自定义序列化工具,  

``` java
@Bean
public MessageConverter jacksonMessageConvertor(){
    return new Jackson2JsonMessageConverter();
}
```

``` 
<dependency>
    <groupId>com.fasterxml.jackson.dataformat</groupId>
    <artifactId>jackson-dataformat-xml</artifactId>
</dependency>
```

### MQ高级
* 可靠性:一个消息至少被消费一次
* 从三端解决消息的可靠性问题
    * 发送者的可靠性
    * MQ
    * 消费者
    * 延迟消息


#### 发送者可靠性
##### 生产者重连

<img src="/img/2026-1-21-RabbitMQ/20260126-094134.png" alt="20260126-094134.png" style="width:70%; height:auto;">

* 这个仅仅只是连接失败的重试
* 阻塞式重试
    * 对性能有要求，建议禁用
    * 如果一定要使用，那就合理配置等待时长

##### 生产者确认
* 如果消息投递到了MQ，但是路由失败，此时会通知PublisherReturn返回路由异常原因，然后返回ACK，告知投递`成功`
* 临时消息投递到MQ，并且入队成功，就会立马返回ACK，告知投递`成功`
* 持久消息投递到MQ，入队成功并且持久化，才会返回ACK
* 其他情况都会返回`NACK`

<img src="/img/2026-1-21-RabbitMQ/20260126-095540.png" alt="20260126-095540.png" style="width:70%; height:auto;">

<img src="/img/2026-1-21-RabbitMQ/20260126-095652.png" alt="20260126-095652.png" style="width:50%; height:auto;">

<img src="/img/2026-1-21-RabbitMQ/20260126-100246.png" alt="20260126-100246.png" style="width:50%; height:auto;">

``` java
    //    publisher-confirm-type: correlated
    //    publisher-returns: true
    @Test
    void testConfirmCallback() throws InterruptedException {
        CorrelationData cd = new CorrelationData(UUID.randomUUID().toString());
        cd.getFuture().addCallback(new ListenableFutureCallback<CorrelationData.Confirm>() {

            @Override
            public void onSuccess(CorrelationData.Confirm result) {
                System.out.println("收到消息回执");
                if (result.isAck()){
                    System.out.println("消息发送成功");
                }else {
                    System.out.println(" 消息发送失败");
                }
            }

            @Override
            public void onFailure(Throwable ex) {
                System.out.println("消息失败");
            }
        });
        rabbitTemplate.convertAndSend("amq.direct", "red","hello",cd);
        Thread.sleep(200);
    }
```

<img src="/img/2026-1-21-RabbitMQ/20260126-101706.png" alt="20260126-101706.png" style="width:80%; height:auto;">


#### MQ的可靠性
* MQ宕机之后，内存中的消息会丢失
* 内存空间是有限的，当消费者故障或者处理过慢时，会导致消息积压，引发MQ阻塞

##### 数据持久化
* 交换机持久化：我们应该创建durable的交换机
* 队列持久化 (我们在spring框架中创建的时候默认是持久化的)
* 消息持久化`delivery_mode=2` (spring默认是持久化消息)

* 当我们发非持久消息的时候，mq存储在内存中，当内存满了之后，mq会把消息持久化，这一阶段mq不会接受新的消息，会有`阻塞`情况的发生
* 对于持久化消息，内存满的时候不会停止接受消息

##### Lazy Queue
* 接收到消息之后直接存进磁盘而不是内存
* 消费者消费消息的时候从磁盘中读取并加载到内存
* 支持数百万
* 从3.12以后，所有都是Lazy Queue模式
* `x-queue-mode =lazy`
* java代码`.lazy()`
* 基于注解`@Argument(name='x-queue-mode',)`

#### 消费者可靠性
##### 消费者确认机制(三种回执)
* ack:
* nack:
* reject: 比如请求参数异常

SpringAMQP已经实现了消息确认功能，并且允许我们通过配置文件选择ACK处理方式，有三种方式:
* none:不处理
* manual: 手动，自己在代码中调用api
* auto: Spring做了AOP   
    * 正常情况:ack
    * 业务异常:nack  一般报错就是这个nack，然后进行重新投递
    * 消息处理或校验参数异常: reject


##### 消息的失败处理策略
``` yaml
stateless: true  #表示无状态，如果存在事务就改为false
retry:
    enabled: true #开启重试机制,默认3次
``` 

* `RejectAndDontRequeueRecoverer`: 重试耗尽之后直接reject
* `ImmediateRequeueMessageRecoverer`: 重试耗尽返回nack
* `RepublishMessageRecoverer`: 重试耗尽之后，将失败消息投递到指定的交换机

``` java
@Configuration
@ConditionalOnProperty(prefix = "spring.rabbitmq.listener.simple.retry",name = "enabled",havingValue = "true")
public class ErrorConfiguration {
    @Bean
    public DirectExchange errorExchange() {
        return new DirectExchange("error.direct");
    }

    @Bean
    public Queue errorQueue() {
        return new Queue("error.queue");
    }

    @Bean
    public Binding errorBinding() {
        return BindingBuilder.bind(errorQueue()).to(errorExchange()).with("error");
    }

    @Bean
    public MessageRecoverer errorMessageConverter(RabbitTemplate rabbitTemplate) {
        return   new RepublishMessageRecoverer(rabbitTemplate,"error.direct","error");
    }
}
```

<img src="/img/2026-1-21-RabbitMQ/20260126-115306.png" alt="20260126-115306.png" style="width:80%; height:auto;">

##### 业务幂等性
* 很有可能出现有一个消息投递多次，造成重复消费
    * 幂等业务: 查询,删除
    * 非幂等: 下单业务，退款业务

* 令牌机制
* 业务判断

<img src="/img/2026-1-21-RabbitMQ/20260126-133034.png" alt="20260126-133034.png" style="width:50%; height:auto;">


#### 延迟时间 

##### 死信交换机

<img src="/img/2026-1-21-RabbitMQ/20260126-133932.png" alt="20260126-133932.png" style="width:50%; height:auto;">

* 我们使用消息队列中消息的过期机制，并给交换机绑定一个没有消费者的队列，
给队列设置`dead-letter-exchange`
* 发消息的时候`setExpiration`
* 这是模拟出来的死信交换机,比较复杂和繁琐


##### 延迟消息插件


<img src="/img/2026-1-21-RabbitMQ/20260126-140341.png" alt="20260126-140341.png" style="width:50%; height:auto;">

``` java

@RabbitListener(bindings = @QueueBinding(
        value = @Queue(value = "delay.direct",durable = "true"),
        exchange = @Exchange(value = "delay.direct",delayed = "true"),
        key = "hi"
))
public void delayedListener(Map<String,Object> map) throws InterruptedException {
    
}


@Test
void testDelay(){
    rabbitTemplate.convertAndSend("delay.queue", "delay","hello world",new MessagePostProcessor() {
        @Override
        public Message postProcessMessage(Message message) throws AmqpException {
            message.getMessageProperties().setDelay(5000);
            return message;
        }
    });
}
```

<img src="/img/2026-1-21-RabbitMQ/20260126-141143.png" alt="20260126-141143.png" style="width:80%; height:auto;">

* 延迟是内置了一个时钟进行实现，如果消息过多
* 延迟时间过长，在并发较高的时候，消息堆积，对MQ压力很大

<img src="/img/2026-1-21-RabbitMQ/20260126-145646.png" alt="20260126-145646.png" style="width:80%; height:auto;">