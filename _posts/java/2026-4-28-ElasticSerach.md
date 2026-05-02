---
layout:     post
title:      "ElasticSearch"
subtitle:   " \"大哥求求你了教教我吧\""
date:       2026-4-28 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - java
---


## 概念

* 索引: 相同类型文档的集合
* 映射: 索引中文档的约束


#### 安装
* es
* kibana
* 安装分词器 -- IK 分词器


## 操作索引库

### mapping 属性
 
 * type
    * text
    * keyword 精确值
    * long integer short byte double float
    * boolean
    * date
    * object
    * geo_point, geo_shape
* index 默认为true，默认设置倒排索引
* analyzer
* properties

### 手写DSL

#### 索引库操作

* 创建索引

``` json

PUT /myindex
{
    "mappings": {
        "properties": {
            "info": {
                "type": "text",
                "analyzer": "ik_smart"
            },
            "email": {
                "type": "keyword",
                "index": false
            },
            "name": {
                "type": "object",
                "properties": {
                    "firstName": {
                        "type": "keyword"
                    }
                }
            }
        }
    }
}
```

* 查询  GET /myindex
* 删除  DELETE /myindex
* 修改  
    * mapping一旦创建无法修改
    * 但是我们可以添加新的字段


#### 文档操作

``` json
POST /index/_doc/文档id
{
    "字段1": "值1",
}

GET /indexname/_doc/文档id
DELETE /indexname/_doc/文档id

PUT /indexname/_doc/文档id// 全量修改 delete+post  如果删除时id未命中，就成了POST新增了
POST /indexname/_update/文档id//局部修改

```

#### copy_to 
创建联合索引

### RestClient

这部分内容直接抛弃，因为client api就是json操作的封装，没什么难度，不需要学

更何况框架常变化


### DSL Query

#### 查询分类
* match all
* full text 全文检索
    * match_query
    * multi_match_query
* 精确查询
    * 一般查找 keyword,数值,日期
    * ids
    * range
    * term
* geo 查询
* 复合查询
    * bool
    * function_score

##### 全文检索查询


``` bash
# 
GET /indexName/_serach
{
    "query":{
        "match_all":{}
    }
}


# 全文检索
 GET aiops_runbooks_v2/_search
{
    "query":{
        "match":{
          "alertName": "ServiceUnavailable"
        }
    }
}


```

* match 与 mutil_match
    * match查询一个字段
    * mutil_match 查询多个字段，但推荐使用copy_to做联合索引


##### 精确查询
* term
* range

<img src="/img/2026-4-28-ElasticSerach/20260428-152717.png" alt="20260428-152717.png" style="width:100%; height:auto;">


##### 地理查询

<img src="/img/2026-4-28-ElasticSerach/20260428-152952.png" alt="20260428-152952.png" style="width:100%; height:auto;">

<img src="/img/2026-4-28-ElasticSerach/20260428-153011.png" alt="20260428-153011.png" style="width:100%; height:auto;">

##### 复合查询
* function score
    * TF算法
    * TF-IDF
    * BM25  es5.0之后

<img src="/img/2026-4-28-ElasticSerach/20260428-154236.png" alt="20260428-154236.png" style="width:100%; height:auto;">


* Boolean Query
    * must
    * should
    * must_not: 不参与算分
    * filter: 必须匹配，不参与算分


##### 结果排序

<img src="/img/2026-4-28-ElasticSerach/20260428-155157.png" alt="20260428-155157.png" style="width:100%; height:auto;">

* 一旦有排序，就会自动放弃算分

##### 分页

<img src="/img/2026-4-28-ElasticSerach/20260428-155602.png" alt="20260428-155602.png" style="width:100%; height:auto;">

<img src="/img/2026-4-28-ElasticSerach/20260428-155906.png" alt="20260428-155906.png" style="width:100%; height:auto;">

<img src="/img/2026-4-28-ElasticSerach/20260428-160057.png" alt="20260428-160057.png" style="width:100%; height:auto;">


##### 高亮

<img src="/img/2026-4-28-ElasticSerach/20260428-160604.png" alt="20260428-160604.png" style="width:100%; height:auto;">