---
layout:     post
title:      "How old are you, Java"
subtitle:   " \"java和我的爱恨情仇\""
date:       2025-12-1 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Java
---

#### 写在前面
本片文章将作为Java复习的第一篇文章，主要内容还是围绕java Collection Framework进行， 以及后面会有线程， 高级语法等。

重点还是在探究一下java更多的底层， 加深对语言的了解。

此外，本文将参考java核心技术卷

>其实，我还是挺感慨的，时隔大半年，HZY再次打开了IDEA， 希望这是一次比较愉快的旅行

## JAVA核心技术卷1
### 第一章 Java程序设计概述
#### Java的优点
* Java除了解释器以外，还有即时编译的功能，在一些执行比较频繁的代码上，将字节码序列转为机器码，提升速度
* Java字符串使用Unicode码
* Java的解释性
* Java处理并发十分优秀

### 第三章 Java基本程序设计
* Java区分大小写： 
* 8种基本类型
	* 4种整型（java没有unsigned）
		* int: 4字节 -2147483648~2147483647 （正负20亿）
		* short: 2字节 -32768~32767
		* long: 8字节 -9223372036854775808~9223372036854775807
		* byte： 1字节 -128~127
	* 2种浮点 (我们不写过多原理在这里)
		* float: 大约6~7位有效数字
		* double： 大约15位有效数字

		>浮点永远不能支持金融计算，二进制中无法精确表示1/10，就像10进制无法精确表示1/3
		所以，如果想要精确表示，使用BigDecimal类
	* 1种字符
		* char

		>这里有一些比较阴间的点，java中char可以用16进制表示\u0000~\uFFFF
		例如 // \u000A is a newline 会报错，因为 Unicode转移序列会在解析代码之前，不过IDEA能提示出来

		>java 使用 UTF-16 作为内部字符编码。一个 char 是一个 UTF-16 编码单元，占 16 bit（2 字节）。但是对于 BMP 以外的 Unicode 字符（如 emoji、乐谱符号），需要使用两个 char（也就是一个“代理对”）才能表示，因此单个 char 无法容纳所有 Unicode 字符。
		我认为这一点十分重要，需要重点熟悉
	* boolean 类型
		**java中布尔不允许数字转布尔**
		比如，if (x=0) 是不被允许的，java中只能有true和false
``` java
//整型
long => 100L | 100l
0x100 | 0X100 //十六进制
010 //八进制
//浮点
1.12f   1.12F
12.2d   12.2D
//注意
Double.isNAN(x)  //合法
Double.NAN == x  //不合法，永远nerve
```
##### 变量与常量
* java10 支持了 var 自动推断变量类型
* final 定义常量
* 类常量
	>public static final double CM_PER_INCH = 2.54
* const 是java保留的关键字，但没有使用
* 枚举类型： enum
* Math类
	* sqrt(w)
	* pow(x,a)
	* Math.PI
	* Math.E
可以使用import static java.lang.Math.*

Math类中都是基于浮点数的，如果想要一个精确的结果，使用StrictMath类
* 经典余数问题
>新手往往绕不开，一个余数到底是正数还是负数，往往会需要做一些优化操作，保证余数不是负数，这里先不探究，我记得之前研究过，把笔记移植过来
* 类型转换
	* 隐式转换 这里需要插一张图，掠过了先
	* 强制转换
	>int a = (int) Math.round(x)
* java的移位运算符
> jav中有>>和>>>所以能很好，准确处理高位是按照原来的填充，还是补0，C++则不好确定>>的高位的处理
* java中字符串类型String是不可变类型
> 也就是说，我们无法通过‘字符数组’这种方式改变字符串
比如，把“Hello”改为“Hellp”，java没有update方法，我们只能用substrin()提取子串再拼接
java中异于其他语言的重要的一点还有String的比较
== 还是 .equals()    请记住，== 只用来判断对象是否处于一个‘内存地址’，而不能比较内容
##### String
书上在这里详细地说了String类，那我们也详细写一些