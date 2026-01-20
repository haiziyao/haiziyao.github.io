---
layout:     post
title:      "快速入门SpringCloud"
subtitle:   " \"简单速通微服务\""
date:       20256-1-18 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Java
---

 
### 微服务简介
老师这里讲的真的很好，等到后面就把图片偷过来

## 开发
### Nacos 注册中心，配置中心
#### Nacos安装
* 下载Nacos
* 在bin目录启动`startup.cmd -m standalone`我们本地测试选择这个模式
* 访问`localhost:8848/nacos`
#### 服务注册
* 依赖`spring-cloud-starter-alibaba-nacos-discovery`
* application配置`spring.cloud.nacos.server-addr=127.0.0.1:8848`
#### 服务发现
* `@EnableDiscoveryClient`
* 调用对应api
    * `DiscoveryClient`是springboot提供的统一接口
    * `NacosServiceDiscovery`是Nacos提供的

``` java
@SpringBootTest(classes = ProductMainApplication.class)
public class Test {

    @Autowired
    DiscoveryClient discoveryClient;

    @Autowired
    NacosServiceDiscovery nacosServiceDiscovery;

    @org.junit.jupiter.api.Test
    void test01(){
        List<String> services = discoveryClient.getServices();
        for (String service : services) {
            System.out.println(service);
            List<ServiceInstance> instances = discoveryClient.getInstances(service);
            for (ServiceInstance instance : instances) {
                System.out.println(instance.getHost() + ":" + instance.getPort());
            }
        }
    }

}
```

#### 远程调用
这部分其实很好理解，我也不想敲代码了。
* 服务发现, 通过`DiscoveryClient` getInstance, 拿到实例
* 我们直接使用`RestTemplate`发请求就行了
* 实现负载均衡
    * 使用`LoadBalancerClient`可以进行负载均衡(轮询)
    * 在`RestTempalte`上面用注解`@LoadBalanced`(轮询)
        * 注意，在使用这个注解后，不需要手动拿service的instance了
        * 直接用`String url = http://service-product/api/params`
        * 也就是说，直接把服务名称嵌入url, 会自动进行动态替换
* 实例缓存:我们肯定不希望每次进行业务时，都需要先找注册中心要服务地址，所以我们选择在第一次调用的时候将服务地址缓存起来(底层已经实现了这个功能)

#### 思考题：注册中心宕机了，远程调用还能成功吗？
* 看有没有缓存建立

#### 配置更新： 集中配置，不停机更新
* 引入依赖: 
* 导入配置`spring.config.import=nacos:filename`
* `@RefreshScope`如果我们使用`@Value`去用值，必须使用这个refresh的注解

* 一旦引入配置中心导入，必须导入配置，要不就禁用检查

##### 优化配置属性使用
* `@ConfigurationProperties`配置了nacos的自动刷新
##### 配置监听
``` java
@Bean
    ApplicationRunner applicationRunner(NacosConfigManager nacosConfigManager) {
        return args -> {
            ConfigService configService = nacosConfigManager.getConfigService();
            configService.addListener("service-order","DEFAULT_GROUP",new Listener() {

                @Override
                public Executor getExecutor() {
                    return Executors.newFixedThreadPool(4);
                }

                @Override
                public void receiveConfigInfo(String s) {
                    System.out.println("变化的配置信息:"+s);
                }
            });
        };
    }
```
##### 面试题
* 配置文件以配置中心为准
* 遵循外部优先
* 先导入优先

>sping.config.import=nacos:service-order.properties,nacos:common.properties
##### 数据隔离
适配多环境
* 区分多套环境
    * 可以使用Namespace命名空间
        * group 分组
            * data-id 数据集 
* 定义多环境

``` yaml
spring.cloud.nacos.config.namespace: dev  (这里要写namespaceId)

spring.cloud.config.import:nacos:common.properties?group = order

```

* yaml多文档模式
``` yaml
spring:
    profiles:
        active: test
spring:
    cloud:
        nacos:
            namespace: ${spring.profiles.active:public}
---
spring:
    config:
        import:
            - nacos:common.properties?group=order
            - nacos:database.properties?group=order
        activate:
            on-profile: test
---
spring:
    config:
        import:
            - nacos:common.properties?group=order
            - nacos:database.properties?group=order
        activate:
            on-profile: dev
---
spring:
    config:
        import:
            - nacos:common.properties?group=order
            - nacos:database.properties?group=order
        activate:
            on-profile: prod

```

### OpenFeign
`@EnableFeignClients`
#### 远程调用 业务api
``` java
@FeignClient("server-product")
public interface OpenFeign {

    @GetMapping("/product/{id}")
    public Product getProduct(@PathVariable Long id);
}
```

>        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-loadbalancer</artifactId>
        </dependency>

#### 远程调用 第三方api
`@FeignClient("server-product",url="{这里定义准确url}")`
我们使用openFeign的时候只需要一个接口，而不需要方法体
#### 小技巧
如果调用业务api，直接把controller拿来
#### 服务端和客户端负载均衡
*  客户端负载均衡
*  服务端负载均衡

#### 日志
* 配置文件
    
    > logging:
  level:
    com.hzy.openfeign: debug
* 配置组件

    >    @Bean
    Logger.Level loggerLevel() {
        return Logger.Level.FULL;
    }

#### 超时控制
* 超时
    * 中断调用
        * 返回错误信息
        * 返回兜底数据 Sentinel
* 超时
    * 连接超时:connnectTimeout 默认10s
    * 读取超时:readTimeout 默认60s

``` yaml
spring:
  cloud:
    openfeign:
      client:
        config:
          default:
            logger-level: full
            connect-timeout: 3000
            read-timeout: 5000
          service-product:
            logger-level: full
            connect-timeout: 3000
            read-timeout: 5000
```

#### 重试机制
* 默认从不测试

``` java
@Bean
Retryer retryer() {
    return new Retryer.Default();//这里可以传入参数
}
```

也可以使用配置文件

#### 拦截器
* 请求拦截器
* 响应拦截器

``` java
//也可以使用配置文件配置，不过我觉得Bean组件最简单
@Component
public class XTokenRequestInterceptor implements RequestInterceptor {
    /**
     * 请求拦截器
     * @param requestTemplate 请求模板
     */
    @Override
    public void apply(RequestTemplate requestTemplate) {
        requestTemplate.header("X-Token", UUID.randomUUID().toString());
        
    }
}
```

#### Fallback兜底返回
这个功能需要配合Sentinel才能使用

这个设计是真的厉害，OpenFeign是接口，而Fallback是实现类，
如果远程调用失败的话，自动去找实现类并执行兜底返回
``` java
@FeignClient(value = "service-product",fallback = ProductFeignClientFallback.class)
public interface ProductOpenFeign {

    @GetMapping("/product/{id}")
    public Product getProduct(@PathVariable Long id);
}


public class ProductFeignClientFallback implements ProductOpenFeign {

    @Override
    public Product getProduct(Long id) {
        //写兜底回调的代码部分
        //
        return null;
    }
}
```
``` yaml
feign:
  sentinel:
    enabled: true
```
### Sentinel
* 定义资源
    * 主流框架自动适配
    * 编程式: SphU API
    * 声明式: @SentinelResource
* 定义规则
    * 流量控制
    * 熔断降级
    * 系统保护
    * 来源访问控制
    * 热点参数

![alt text](../../img\java\springcloud\image-1.png)
#### 整合
* 打开sentinel dashboard
* 配置文件

    ``` yaml
    spring.cloud:
        sentinel:
            transport:
                dashboard: localhost:8080
            eager: true
    ```

* `@SentinelResource(value="resourceName")` 即可定义为资源
#### 异常处理
Sentinel的异常处理比较复杂
`BlockException`
##### Web接口异常
* 默认走一个WebInterceptor，有一个默认的preHandler，
* 所以可以自定义preHandler来自定义异常错误信息

``` java
@Component
public class MyBlockExceptionHandler implements BlockExceptionHandler {

    ObjectMapper objectMapper = new ObjectMapper();
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, String s, BlockException e) throws Exception {
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        R error = R.error(500,s + " 被Sentinel限制了,原因 : "+e.getMessage()+" 类是："+getClass());
        String json = objectMapper.writeValueAsString(error);
        out.write(json);
        out.flush();
        out.close();
    }
}
```

##### @SentinelResource
* 实现有一个`SentinelResourceAspect`，对于所有标注了注解的进行处理
* 底层对于异常处理
    * blockhandler
    * fallback
    * default-fallback
    * 以上三个都没有，就走springboot的异常处理

``` java
@SentinelResource(value = "createOrder",blockHandler = "createdefaulhandler")
@Override
public Order create(Long userId, Long productIde) {
    return ;//业务逻辑;
}

Order createdefaulhandler(Long userId, Long productIde, BlockException e){
//业务逻辑
    return order;
}
```

##### OpenFeign调用
* openfeign自己有自己的fallback
* 兜底回调
##### SphU硬编码
上述说的几种底层都是通过sphu实现的，所以我们也可以直接调用sphu
#### 流控规则
Sentinel对请求进行限流，防止系统崩溃
* 阈值类型
    * QPS： 大多数使用这个
    * 并发线程数：性能低
* 集群
    * 单机均摊
    * 总体阈值
#### 流控模式
* 链路
    * 入口资源

    >解释，我们的createOrder模块可以分为,普通调用和秒杀调用，我们只希望限制秒杀调用下的createOrder，所以就可以控制入口资源路径来区分开来
    * 关闭上下文统一

    > spring.cloud.web-context-unity: false

* 关联
    * 对数据库的操作分为读和写，在请求较大的时候，我们希望给读限流，优先进行写操作，就可以建立关联限流
#### 流控效果
* 快速失败
* Warm Up 
    * QPS：
    * Period : 冷启动的总时间
* 匀速排队：把请求平均分配在每秒内
    * QPS：大于1000时候就无效了，因为可处理最低单位是毫秒
    * timeout: 最大排队时间
    * 漏桶算法和虚拟队列实现
#### 熔断规则
熔断在客户端进行配置，也就是配置OpenFeign
* 熔断降级
    * 慢调用比例
        * RT: 请求最大响应时间
        * 阈值:比例
        * 熔断时长
        * 统计时长
        * 最小请求数量:5
    * 异常比例
        * 比例阈值
        * 熔断时长
        * 最小请求数
        * 统计时长
    * 异常数
        * 异常数
        * 熔断时长
        * 最小请求数
        * 统计时长

##### 工作原理
如果检测到`异常情况`(见上),我们就断开开关,所有请求就会快速失败,拒绝访问,但这种断开在`window`(窗口期)过去后,变为`Half-Open`状态,会放行一个`探测请求`,如果探测请求成功了,我们就把开关闭合,如果失败了,那就再循环一个`window`

#### 热点规则
更细致的限制,可对资源进行对参数的限制
* 每个用户QPS不超过1 : 对userId限制
* VVIP用户不限流
* 666是下架商品,不允许访问

目前对`Dubbo`支持,对Web接口默认不支持,需要自定义埋点,而且资源名不能重复

* 参数索引: 0表示第一个参数,携带就开始限制
* 高级:参数例外项

#### blockhandler&fallback
* blockhandler 只处理 BlockException
* fallback 函数里面可以捕获所有异常
* 调用规则,有blockhandler优先,没有再找fallback
* 热点规则产生的是ParamFlowExceptions是BlockException子类,blockhandler可以捕获
#### 授权规则
被gateway代替了
#### 系统规则
控制不精准,没啥用

#### Sentinel和Nacos整合持久化配置
TODO:

这是重点,但是没讲

### GateWay
* Reactive Server: 响应式 (recommended)
* Server MVC: 传统网关,性能差

#### 规则配置
``` yaml
spring:
  cloud:
    gateway:
      routes:
        - id: order-route
          uri: lb://service-order  #lb表示负载均衡
          predicates:
            - Path=/api/order/**
```

#### 路由
* id: 
* uri:  `GatewayHandlerMapping`
* predicate: `GatewayWebHandler`
* filter:
* order: 数字越小优先级越高
* metedata:
#### 断言
* predicates:
    * name: Path  每个name都来自于一个断言工厂
    * args:
        * patterns:
        * matchTrailingSlash: true (默认true不需要改)

断言有多个规则,必须完全匹配才能命中

#### 自定义断言工厂
``` java
@Component
public class VipRoutePredicateFactory extends AbstractRoutePredicateFactory<VipRoutePredicateFactory.Config> {

        public VipRoutePredicateFactory() {
            super(Config.class);
        }

    @Override
    public Predicate<ServerWebExchange> apply(Config config) {

        return new GatewayPredicate() {
            @Override
            public boolean test(ServerWebExchange serverWebExchange) {
                ServerHttpRequest request = serverWebExchange.getRequest();
                String first = request.getQueryParams().getFirst(config.param);


                return StringUtils.hasText(first) && first.equals(config.value);
            }
        };
    }

    @Override
    public List<String> shortcutFieldOrder() {
        return Arrays.asList("param","value");
    }

    @Validated
    public static class Config {
        private @NotEmpty String param;
        private @NotEmpty String value;

        public @NotEmpty String getParam() {
            return param;
        }

        public void setParam(@NotEmpty String param) {
            this.param = param;
        }

        public @NotEmpty String getValue() {
            return value;
        }

        public void setValue(@NotEmpty String value) {
            this.value = value;
        }
    }
}
```

#### Filter路径重写
``` yaml
filters:
    - RewritPath=/api/order/?(?<segment>.*),/$\{segment}
```

#### 默认filter
``` yaml
spring:
    cloud:
        gateway:
            default-filters:
                ...
```
#### GlobalFilter
``` java
@Component
public class RtGlobalFilter implements GlobalFilter, Ordered {


    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        ServerHttpResponse response = exchange.getResponse();

        long startTime = System.currentTimeMillis();
        String uri = request.getURI().toString();
        System.out.println("uri +" + uri+"startTime = " + startTime);

        //==============上面是前置逻辑
        Mono<Void> filter = chain.filter(exchange).doFinally((result)->{
            long endTime = System.currentTimeMillis();
            System.out.println("endTime = " + endTime);
        });
        //由于上面这个方法是异步执行，所以下面写的代码不是后置逻辑
        // 我们需要启动另一个函数来增添后置逻辑


        return filter;
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
```
#### 自定义Filter
``` java
@Component
public class OnceTokenGatewayFilterFactory extends AbstractNameValueGatewayFilterFactory {
    @Override
    public GatewayFilter apply(AbstractNameValueGatewayFilterFactory.NameValueConfig config) {
        return new GatewayFilter() {
            @Override
            public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {

                return chain.filter(exchange).then(Mono.fromRunnable(() -> {
                    ServerHttpRequest request = exchange.getRequest();
                    ServerHttpResponse response = exchange.getResponse();
                    HttpHeaders headers = response.getHeaders();
                    String value = config.getValue();
                    if ("uuid".equalsIgnoreCase(value)) {
                        value = UUID.randomUUID().toString();
                    }
                    
                    //这里放jwt等其他算法

                    headers.add(config.getName(),value);
                }));
            }
        };
    }
}
```

#### 全局跨域
``` yaml
spring:
  cloud:
    gateway:
      globalcors:
        cors-configurations:
          '[/**]':
            allowedOrigins: "https://docs.spring.io"
            allowedMethods:
              - GET
```
#### 微服务之间的调用经过网关吗
* 一般不经过
* 但是可以自定义配置
### Seata 分布式事务 
* TC 事务协调者
* TM 事务管理器
* RM 资源管理器
#### 整合seata
> file.conf
 service {
   #transaction service group mapping
   vgroupMapping.default_tx_group = "default"
   #only support when registry.type=file, please don't set multiple addresses
   default.grouplist = "127.0.0.1:8091"
   #degrade, current not support
   enableDegrade = false
   #disable seata
   disableGlobalTransaction = false
 }

* 配置好seata环境
* 在总controller上标注`@GlobalTransactional`


#### 二阶提交协议
* 第一阶段
    * 业务提交
    * undo_log 提交
* 第二阶段
    * 收到TC请求
        * 异步任务删除undo_log
    * 搜到TC回滚
        * 找到undo_log
        * 做数据校验，若数据和外部数据不一致（外部渠道）
        * 回滚数据
#### 四种事务模式
`seta.data-source-proxy-model:AT`
* AT：
* XA: 性能较低
* TCC: 全手动的二阶段分布式,自己实现所有方法
    * 比如：有的事务里面有发邮件，邮件不能撤回，所以要自己定义个重发邮件
    * 用于处理广义事务
* Saga： 结合消息队列