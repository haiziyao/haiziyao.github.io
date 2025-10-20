---
layout:     post
title:      "Math Modeling"
subtitle:   " \"MathModeling further learn\""
date:       2025-10-18 00:00:00
author:     "HJL's team(hzy jxt lxx)"
header-img: ""
catalog: true
tags:
    - MathModeling
---

 #### 数据清洗
 * 数据读写
 > pd.read_csv()
 > pd.read_excel()
 * 数据的探索和描述
 >df.info()
 >df.describe()
 * 数据简单处理
 >去除空格
 >大小写的转换
 * 重复值的处理
 >duplicated()
 >drop_duplicates()
 * 缺失值的处理
 >删除缺失值
 >均值填充法
 >向前填充,向后填充
 >模型填补法
 * 异常值的处理
 >删除异常值
 >作为缺失值处理
 >平均值修正，盖帽法修正
 >不处理：业务分析挖掘价值
 * 文本字符的处理
 >去除前后空格处理
 >处理中间有，() 之类的，用replace()
 >正则表达式提取
 * 时间格式序列的处理
>系统时间格式化
>系统时间和时间戳相互转换
>年月日的提取

#### seaborn函数
Seaborn 是一个基于 Matplotlib 的数据可视化库，专注于统计图形的绘制，旨在简化数据可视化的过程。

Seaborn 提供了一些简单的高级接口，可以轻松地绘制各种统计图形，包括散点图、折线图、柱状图、热图等，而且具有良好的美学效果。

>利用seaborn函数对相关性矩阵进行展示是一个不错的选择

#### pandas的高级篇章
##### pandas内嵌matplotlib
[参考：菜鸟教程](https://www.runoob.com/pandas/pandas-matplotlib.html)
>kind : line,bar,barh,hist,scatter,box,kde,pie,area
``` py
data = {'Category': ['A', 'B', 'C', 'D'],
        'Value': [10, 15, 7, 12]}
df = pd.DataFrame(data)

df.plot(kind='bar',x = 'Category',y = 'Value',title="aa",
    xlabel="Category",ylabel="Value",figsize=(8,5))
plt.show()
```
##### 利用Seaborn
``` py
#此处省略
```