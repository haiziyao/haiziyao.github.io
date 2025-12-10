---
layout:     post
title:      "How old are you, Java"
subtitle:   " \"java和我的爱恨情仇\""
date:       2025-12-1 12:00:00
author:     "HZY"
header-img: "img/java/1.png"
catalog: true
tags:
    - Java
---

 ## Java核心技术卷1

 ### 接口 lambda表达式 内部类
 ##### 接口
 ``` java
//接口这个东西我们用实例进行复习


 @Override
    public int compareTo(Example o) {
        return Integer.compare(this.num , o.num);
    }

	public class Example implements Comparable<Example> {}  //不加泛型，默认就是和Obj比较


//java.lang.Comparable<T>  
int compareTo(T other);
//java.util.Arrays
static void sort(Object[] a)//要求obj实现了Comparable接口

//接口不可new，不能实例化，但可接收参数
Comparable e = new Example();
// 接口可以有静态变量,自动为 public static final 


//记录 和 枚举可以实现接口

//接口的默认方法

default boolean isEmpty() {return size() == 0;}
 ```
常见问题
 ``` java
 //默认方法冲突
 // 同样的方法，超类中有，接口中也有，
public class Son extends Person implements Child,Student{
	//超类优先原则：超类中有，接口中的默认方法被忽略

	//接口冲突，自己调用包名区分
	public String getName(){
		return java.bagname.Child.getName();
	}
}
```
``` java
public interface MyInterface {

    // 1. 抽象方法
    void f1();

    // 2. 默认方法
    default void f2() {
        System.out.println("default implement");
    }

    // 3. 静态方法
    static void f3() {
        System.out.println("static method");
    }

    // 4. 私有方法（Java 9+）
    private void helper() {
        System.out.println("helper");
    }
}
 ```
![](/img/java/image5.png)
 ##### 接口与回调
 ``` java
//这里就是一个java的Timer的东西，没有太多其他的
 ```

 ##### Comparator
对于String的排序，已经实现了Comparable接口的compareTo()方法，
如果我们想换一种排序呢？比如，字符串里面有“hzy”就优先排列
那么我们就要借助另一个接口
 ``` java
Arrays.sort(Object[] objs,new hzyStringCompare());

public hzyStringCompare implements Comparetor<T>(){
	//实现流程
} 
//这种以后肯定用lambda表达式优化了
 ```
 ##### 克隆
 java中提供clone默认是浅拷贝
 Java 的设计者刻意不让 clone 做自动深拷贝，主要原因是：

1. 无法确定字段是否需要深拷贝（例如字段是不可变的、内部共享的等）。
2. 性能不可控（盲目深拷贝会引发大量对象创建）。
3. 反射深拷贝会绕过封装，不安全。
4. 很多对象含有无法拷贝的资源（文件句柄、Socket、线程等）。

 ``` java
public class Employee implements Cloneable{
    public Employee clone() throws CloneNotSupportedException {
       Employee clone = (Employee) super.clone();
	   clone.field1 = (Field1) field1.clone();
	   clone.field2 = (Field2) field2.clone();
	   return clone;
    }
}

//深拷贝

 ```
 ##### lambda表达式
 Lambda 表达式本身不是对象，但在与函数式接口绑定后，会在运行时生成该接口的实例对象。
 ``` java
//对于只有一个抽象方法的接口，就可以用lambda
 ```