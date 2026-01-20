---
layout:     post
title:      "尚庭公寓"
subtitle:   " \"成为J佬的一天\""
date:       2025-12-28 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Java
---

 

### MinIO
* 启动服务:minio server xxx路径
* 配置服务配置文件


#### MinIO核心概念
* Object 对象
* Bucket 存储桶
* Endpoint 端点
* Access Key 和 Secret key 

#### 使用步骤
1. 登录: 
    * 注意，防火墙是否关闭，端口是否放开
    * 登录密码在我们的EnvironmentFile配置文件中
2. 创建存储桶
3. 上传图片
    * 找到目标桶
    * 上传图片
4. 访问图片
    * 图片url就是`MinIO地址`+`Endpoint`+`存储路径`
    * 懂得都懂，默认权限就是private,肯定访问不到
    * 可以自定义访问权限Custom
    * 这个Custom自定义权限我是真的不懂不会写
#### MinIO Java SDK
``` xml
<dependency>
    <groupId>io.minio</groupId>
    <artifactId>minio</artifactId>
    <version>8.5.3</version>
</dependency>
```

### 开发

#### 逻辑删除功能
使用`配置`或者`@TableLogic`注解
* 注意，这个功能只对我们Mybatis-plus有用，如果自己定义的sql，那就没用了
* 只要有`@TableLogic` remove操作就是逻辑删除
#### @JsonIgnore
* 删去不需要的信息，比如创建时间，is_delete
* jackon提供的

#### 自动填充
* 加注解@TableField(fill = FieldFill.INSERT )
* 填充内容

    ``` java
    @Component
    public class MybatisMetaObjectHandler implements MetaObjectHandler {
        @Override
        public void insertFill(MetaObject metaObject) {
            this.strictInsertFill(metaObject, "createTime", Date.class, new Date());
        }

        @Override
        public void updateFill(MetaObject metaObject) {
            this.strictUpdateFill(metaObject, "updateTime", Date.class, new Date());
        }
    }
    ```

#### 流程中所有的类型转换
* 一旦涉及到枚举，就会多次进行类型转换
    * WebDataBinder : Enum entity -> 前端数据(要code而不是_SUCCESS_)
    * TypeHandler : Enum entity -> 数据库要查的属性code
    * HTTPMessageConverter:前端数据->Enum entity
* SpringMVC提供了String->Enum的转换器，但是只能通过实例名称转换，不能通过Enum的code
* 所以我们只能自己转换

    ``` java

    @Component
    public class StringToItemTypeConverter implements Converter<String, ItemType> {
        @Override
        public ItemType convert(String code) {

            for (ItemType value : ItemType.values()) {
                if (value.getCode().equals(Integer.valueOf(code))) {
                    return value;
                }
            }
            throw new IllegalArgumentException("code非法");
        }
    }

    @Configuration
    public class WebMvcConfiguration implements WebMvcConfigurer {

        @Autowired
        private StringToItemTypeConverter stringToItemTypeConverter;

        @Override
        public void addFormatters(FormatterRegistry registry) {
            registry.addConverter(this.stringToItemTypeConverter);
        }
    }
    /**
     *    在 Spring Boot 中，只要你的 Converter 被注册成 Bean（如 @Component），就会被自动加入 ConversionService，根本不需要手写 WebMvcConfigurer。
     */
    ```

##### ConverterFactory
``` java
@Component
public class StringToBaseTypeConveter implements ConverterFactory<String, BaseEnum> {
    @Override
    public <T extends BaseEnum> Converter<String, T> getConverter(Class<T> targetType) {
        return new Converter<String, T>() {
            @Override
            public T convert(String source) {
                T[] enumConstants = targetType.getEnumConstants();
                for (T enumConstant : enumConstants) {
                    if (enumConstant.getCode().equals(Integer.valueOf(source))) {
                        return enumConstant;
                    }
                }
                throw new IllegalArgumentException();
            }
        };
    }
}

```
##### TypeHandler (MP)
* `@EnumValue`: 可实现枚举对象和枚举属性值的转换

##### HTTPMessageConveter
* 依赖于jackson
* `@JsonValue`

##### 枚举类属性映射
``` java
@Data
@ConfigurationProperties(prefix="minio")
public class MinIOProperties{
    private String endpoint;

}


//在配置类上写这个注解注册我们的配置信息类
@ConfigurationPropertiesScan("包名")
@EnableConfigurationProperties(类名)
//二选一就行
```

#### MinIO上传文件
* 熟悉MinIO上传文件的流程
* 理解ContentType的作用
    
    >这里的代码cv就行
* MultipartFile

``` java
//可以获取很多文件信息
System.out.println(file.getName());
System.out.println(file.getOriginalFilename());
System.out.println(file.getContentType());
System.out.println(file.getSize());
```

#### 全局异常处理
``` java
@ResponseBody
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(value = Exception.class)
    public Result exceptionHandler(Exception e){
        e.printStackTrace();
        return Result.fail();
    }
}
```

#### saveOrupdate多张表
* 执行insert语句后会触发主键回显
    * 补充，就算对于mp中的saveOrupdate操作，也并不是都能触发主键回显的，只有当走的是save也就是insert操作的时候才会触发主键回显，对于update语句则不会
* stream流操作
    * map适用于类型转换：类型转换，list->newList
    * foreach适用于副操作：打印等等


``` java
//判断要更新还是纯添加
boolean is_update = apartmentSubmitVo.getId() != null;
//注意下面这一步会触发主键回显
//注意，只有执行insert语句才可能触发主键回显
//也就是说这句话如果走的是update语句，也照样不会触发主键回显
this.saveOrUpdate(apartmentSubmitVo);


// 删除图片
LambdaQueryWrapper<GraphInfo> graphInfoLambdaQueryWrapper = new LambdaQueryWrapper<>();
graphInfoLambdaQueryWrapper.eq(GraphInfo::getId, apartmentSubmitVo.getId())
        .eq(GraphInfo::getItemType,ItemType.APARTMENT);
graphInfoService.remove(graphInfoLambdaQueryWrapper);

//添加图片
List<GraphVo> graphVoList = apartmentSubmitVo.getGraphVoList();
if (!CollectionUtils.isEmpty(graphVoList)) {
List<GraphInfo> graphInfoList = graphVoList.stream().map(graphVo -> {
    GraphInfo graphInfo = new GraphInfo();
    graphInfo.setName(graphVo.getName());
    graphInfo.setUrl(graphVo.getUrl());
    graphInfo.setItemType(ItemType.APARTMENT);
    graphInfo.setItemId(apartmentSubmitVo.getId());
    return graphInfo;
}).collect(Collectors.toList());
graphInfoService.saveBatch(graphInfoList);
}
```

#### 分页查询
* 分页插件配置类配置
* 编写较为复杂的sql语句

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.atguigu.lease.web.admin.mapper.ApartmentInfoMapper">

    <select id="pageItem" resultType="com.atguigu.lease.web.admin.vo.apartment.ApartmentItemVo">
    select
        ai.id,
        ai.name,
        ai.introduction,
        ai.district_id,
        ai.district_name,
        ai.city_id,
        ai.city_name,
        ai.province_id,
        ai.province_name,
        ai.address_detail,
        ai.latitude,
        ai.longitude,
        ai.phone,
        ai.is_release,
        ai.create_time,
        ai.update_time,
        ai.is_deleted,
        ifnull(ri.cnn,0) total_room_count,
        ifnull(ri.cnn,0)-ifnull(lg.cnn,0) free_room_count
        from
            (select id,
                name,
                introduction,
                district_id,
                district_name,
                city_id,
                city_name,
                province_id,
                province_name,
                address_detail,
                latitude,
                longitude,
                phone,
                is_release,
                create_time,
                update_time,
                is_deleted
         from apartment_info
        <where>
            is_deleted = 0
            <if test="queryVo.provinceId != null">
                and apartment_info.province_id = #{queryVo.provinceId}
            </if>
            <if test="queryVo.cityId != null">
                and apartment_info.city_id = #{queryVo.cityId}
            </if>
            <if test="queryVo.districtId != null">
                and apartment_info.district_id = #{queryVo.districtId}
            </if>
        </where>)
        ai

        left join
        (select apartment_id, count(*) cnn
         from lease_agreement
         where is_deleted = 0
           and status in (2, 5)
         group by apartment_id)
        lg on ai.id = lg.apartment_id

        left join
        (select apartment_id, count(*) cnn
         from room_info
         where is_deleted = 0
           and is_release = 1
         group by apartment_id)
        ri on ai.id = ri.apartment_id

    </select>
</mapper>

```

##### 参数展平配置
``` xml
springdoc:
    default-flat-param-object: true
```


#### 多表查询拼接
在我们一个service需要对多张表进行操作，比如十几张表，我们如果还是选择使用sql进行拼接，这其实有点复杂

我们可以使用多次查询，然后再封装一下各个数据，再返回给前端。

#### 多次查询 or Sql连接
1. 譬如我们上面的分页操作，我们需要对一页里每一条数据进行查对应的其他表中的数据，如果我们自己手动查，需要一个循环慢慢查，很复杂，所以这种情况下我们选择复杂sql，在数据库方面查询
2. 但是对于一个根据id查这个商品在其他各种表的信息，我们就可以使用多次sql，然后进行数据拼接，因为这时候我们永远有id这个条件，方便我们进行查询

所以对于不用的需求，我们应该选择不同的方式进行封装数据，不要一昧凭感觉

* 注意：在上面第二条中，我们可能会遇到这种情况，我们得到的数据是多表的一个VO，我们自定义sql语句查询比较好，而不是查多次再手动拼接
#### 删除数据
* 如果删除一个大类，我们在后台应该判断这个大类的子类是否为null
* 如果不是null，我们就throw一个自定义异常，并return 一个枚举状态码
* 这样方便我们对各种异常情况进行处理

#### 时间格式与时区

 
  
  `ViewAppointment`实体类中的`appointmentTime`字段为`Date`类型，`Date`类型的字段在序列化成JSON字符串时，需要考虑两个点，分别是**格式**和**时区**。本项目使用JSON序列化框架为Jackson，具体配置如下
  
  - **格式**
  
    格式可按照字段单独配置，也可全局配置，下面分别介绍
  
    - **单独配置**
  
      在指定字段增加`@JsonFormat`注解，如下
  
      ```java
      @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
      private Date appointmentTime;
      ```
  
    - **全局配置**
  
      在`application.yml`中增加如下内容
  
      ```yml
      spring:
        jackson:
          date-format: yyyy-MM-dd HH:mm:ss
      ```
  
  - **时区**
  
    时区同样可按照字段单独配置，也可全局配置，下面分别介绍
  
    - **单独配置**
  
      在指定字段增加`@JsonFormat`注解，如下
  
      ```java
      @JsonFormat(timezone = "GMT+8")
      private Date appointmentTime;
      ```
  
    - **全局配置**
  
      ```yml
      spring:
        jackson:
          time-zone: GMT+8
      ```
  
  推荐格式按照字段单独配置，时区全局配置。


#### 定时任务
本节内容是通过定时任务定时检查租约是否到期。SpringBoot内置了定时任务，具体实现如下。

- 启用Spring Boot定时任务

  在SpringBoot启动类上增加`@EnableScheduling`注解，如下

  ```java
  @SpringBootApplication
  @EnableScheduling
  public class AdminWebApplication {
      public static void main(String[] args) {
          SpringApplication.run(AdminWebApplication.class, args);
      }
  }
  ```

- 编写定时逻辑

  在**web-admin模块**下创建`com.atguigu.lease.web.admin.schedule.ScheduledTasks`类，内容如下

  ```java
  @Component
  public class ScheduledTasks {
  
      @Autowired
      private LeaseAgreementService leaseAgreementService;
  
      @Scheduled(cron = "0 0 0 * * *")
      public void checkLeaseStatus() {
  
          LambdaUpdateWrapper<LeaseAgreement> updateWrapper = new LambdaUpdateWrapper<>();
          Date now = new Date();
          updateWrapper.le(LeaseAgreement::getLeaseEndDate, now);
          updateWrapper.eq(LeaseAgreement::getStatus, LeaseStatus.SIGNED);
          updateWrapper.in(LeaseAgreement::getStatus, LeaseStatus.SIGNED, LeaseStatus.WITHDRAWING);
  
          leaseAgreementService.update(updateWrapper);
      }
  }
  ```

  **知识点**:

  SpringBoot中的cron表达式语法如下
  
  ```
    ┌───────────── second (0-59)
    │ ┌───────────── minute (0 - 59)
    │ │ ┌───────────── hour (0 - 23)
    │ │ │ ┌───────────── day of the month (1 - 31)
    │ │ │ │ ┌───────────── month (1 - 12) (or JAN-DEC)
    │ │ │ │ │ ┌───────────── day of the week (0 - 7)
    │ │ │ │ │ │          (0 or 7 is Sunday, or MON-SUN)
    │ │ │ │ │ │
    * * * * * *
  ```

#### 隐藏字段
* 对于有些时候，我们希望隐藏掉`UserInfo`里面的password字段
* 但是我们又懒得去做不同的vo
* 所以我们直接选择偷懒
* MP提供有现成的字段`@TableField(value = "password", select = false)`
* 这里其实还有另一个比较好用的东西`@IgnoreJson`记得区分一下使用情景

#### 密码处理
  常用于处理密码的单向函数（算法）有MD5、SHA-256等，**Apache Commons**提供了一个工具类`DigestUtils`，其中就包含上述算法的实现

``` xml
<dependency>
    <groupId>commons-codec</groupId>
    <artifactId>commons-codec</artifactId>
</dependency>
```
#### Mybatis-Plus update strategy

使用Mybatis-Plus提供的更新方法时，若实体中的字段为`null`，默认情况下，最终生成的update语句中，不会包含该字段。若想改变默认行为，可做以下配置。
* 全局配置

在`application.yml`中配置如下参数

``` xml
mybatis-plus:
global-config:
    db-config:
    update-strategy: <strategy>
```

**注**：上述`<strategy>`可选值有：`ignore`、`not_null`、`not_empty`、`never`，默认值为`not_null`

* `ignore`：忽略空值判断，不管字段是否为空，都会进行更新
* `not_null`：进行非空判断，字段非空才会进行判断

* `not_empty`：进行非空判断，并进行非空串（""）判断，主要针对字符串类型

* `never`：从不进行更新，不管该字段为何值，都不更新

* 局部配置

    在实体类中的具体字段通过`@TableField`注解进行配置，如下：

    ```java
    @Schema(description = "密码")
    @TableField(value = "password", updateStrategy = FieldStrategy.NOT_EMPTY)
    private String password;
    ```


#### 用户登录
* Session
* JWT

``` xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
</dependency>

<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <scope>runtime</scope>
</dependency>

<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <scope>runtime</scope>
</dependency>
```
#### 验证码生成工具

```xml
<dependency>
<groupId>com.github.whvcse</groupId>
<artifactId>easy-captcha</artifactId>
</dependency>
```
#### 用户登录
* 使用Interceptor进行请求拦截
    * 特别注意要放行我们的swagger
    * 放行登录的所有接口
* 使用localthread存储用户信息，减少token解析次数

#### @Conditional
`@ConditionalOnProperty(name = "minio.endpoint)`

#### 异步操作
* 在 Spring Boot 主应用程序类上添加 `@EnableAsync` 注解
* 在要进行异步处理的方法上添加 `@Async` 注解


### 部署

#### 代理
* 正向代理
* 反向代理
#### block
* main 
    * user nginx;
    * worker_process auto;  //会将cpu核数作为进程数
    * error_log 配置全局错误日志文件路径
* events block
    比较难
* http block 
    * access_log: 指定访问日志的路径
    * log_formart: 
    * include 引入conf文件
* server block //被http block引入
    * listen: 端口号
    * server_name: 域名或ip
    * location /路径
        * root  /var/  从本地拿资源
        * proxy_pass http:  转发

#### 案例