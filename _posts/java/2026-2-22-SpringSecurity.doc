---
layout:     post
title:      "SpringSecurity"
subtitle:   " \"learn to login in\""
date:       2026-2-22 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Java
---

### 环境搭建

### 认证
#### 登陆校验流程

<img src="/img/2026-2-22-SpringSecurity/20260222-061638.png" alt="20260222-061638.png" style="width:100%; height:auto;">

#### 基本原理
* 本质是一个过滤器链

 <img src="/img/2026-2-22-SpringSecurity/20260222-062524.png" alt="20260222-062524.png" style="width:100%; height:auto;">

 <img src="/img/2026-2-22-SpringSecurity/20260222-063032.png" alt="20260222-063032.png" style="width:100%; height:auto;">

 #### 思路分析
 * 自定义登录接口->ProviderManager->DaoAuthenticalProvider->自定义UserDetailService,通过就生成jwt
 * JWT认证过滤器
    * 获取token
    * 解析token
    * 从redis中获取用户信息
    * 存入SecurityContextHolder

我推荐直接使用这三个库，不需要配置！！！

``` xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.13.0</version>
</dependency>

<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.13.0</version>
    <scope>runtime</scope>
</dependency>

<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.13.0</version>
    <scope>runtime</scope>
</dependency>
```