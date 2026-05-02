---
layout:     post
title:      "Learn From Java Projects"
subtitle:   " \"学习java开源项目\""
date:       2026-3-3 12:00:00
author:     "HZY"
header-img: "img/java/1.png"
catalog: true
tags:
    - java
---


### 没绷住系列

* `@Slf4j`来自`Lombok `

``` java
private static final Logger log =
    LoggerFactory.getLogger(A.class);  //作为某个类的私有字段

@Slf4j  // 可以替代上面那句话，也就是在编译期生成
        //所以这就解释了为啥我们需要Lombook插件，IDE 需要理解 Lombok 的 AST 变换
        //所以很多大厂不喜欢用，因为侵入编译流程
```