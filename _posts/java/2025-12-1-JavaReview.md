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

#### 写在前面
本片文章将作为Java复习的第一篇文章 

重点还是在探究一下java更多的底层， 加深对语言的了解。

此外，本文将参考java核心技术卷

>其实，我还是挺感慨的，时隔大半年，HZY再次打开了IDEA， 希望这是一次比较愉快的旅行

## JAVA核心技术卷1 
>本篇文章为 (1~5章节) 
第5章 包含反射！
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
>这部分hzy并没有完全按照书上的逻辑推进，而是只写了相对重要或者不熟悉的，对于完全熟悉的，则自动跳过

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
``` java
char charAt(int index)        //不怎么推荐使用吧，除非你保证你知道底层原理，不会出现···
boolean isEmpty()
boolean isBlank()
boolean equals(Object other)
boolean equalsignoreCase(String other)
boolean startWith(String prefix)
boolean endWith(String suffix)
int indexOf()  //这个方法有很多变种
String replace(CharSequence oldstr,CharSequence newstr)
String substring(int begin)
String substring(int begin,int end)
String toLowerCase()
String toUpperCase()
String strip()   //这个函数要记住，不要使用trim()
String join(CharSequence dolimiter, CharSequence elements) 
String repeat(int count)  //java11 才加  

String greeting = """
He\
llo
World""";
//这个转义符可以和下一行连接

```
上面的CharSequence是一个属于字符串的接口，String,StringBuilder,StringBuffer,CharBuffer都属于这个接口

直接使用Ctrl + H / Ctrl + Alt + U 查看类继承
##### StringBuilder | StringBuffer
这俩的api都是一样的，不过，StringBuilder效率更高，但StringBuffer支持多线程
``` java
StringBuilder builder = new StringBuilder()
builder.append(ch)
builder.append(str)
String resultstr = builder.toString()

builder.appendCodePoint(int cp) //追加一个码点, 我是新我不用
builder.insert(int offset,char c)
builder.delete(int startindex,int endindex)

```
##### java OI
``` java
//初学者OI套
import java.util.*

Scanner in = new Scanner(System.in);
String str = in.nextLine();   //提取一行，以换行符结束
String word = in.next();   //遇见空格就停止
int age = in.nextInteger();

System.out.print()

// Console类
Console cons = System.Console()
String username = cons.readLine("User name:")
//不过这个玩意，你在IDEA里面一定是null，只有在控制台里面才能正常执行

//Scanner 的api
Scanner(InputStream in)
String nextLine()
String next()
int nextInt()
double nextDouble()

new Scanner(Path.of(""),StandardCharsets.UTF-8)
//sout
System.out.print();
System.out.printf();
System.out.println();

System.out.printf() //沿用c风格

```
>我们这里补充许多java coder 都会遇到的一个问题，在IDEA里，总是找不到jvm启动的时候的执行目录在哪里
我们这里来说一下，调用 System.getProperty("user.dir") 就可以知道了 

``` java
System.out.println(System.getProperty("user.dir"));
Scanner file = new Scanner(Path.of("statics/a.txt"), StandardCharsets.UTF_8);
System.out.println(file.nextLine());
```
对于OI先说到这里不能废太多篇幅
##### 控制流程
条件循环分支
``` java
if - else if - else;
while();
do{}while();
for();
switch (){};
//这里我们说说switch
switch (choice) {
	case 1 -> ...
	case 0 -> ...
	case 2 -> ...
	case 3 -> ...
	default -> 
}
switch (choice) {
	case 1 : ... break;
}

//下面我们来看看优美的switch
//无直通行为
int num = switch (choice) {
	case 1,2 -> {
		System.out.print("我赢");
		yield 6;
	} 
	case 3 -> yield 7;
	default -> yield 8;
}
switch (choice) {
	case 1,2 -> {
		System.out.print("我赢");
		num = 6;
	} 
	case 3 -> num = 7;
	default -> num = 8;
}

//把上面箭头换成冒号，就有直通了，你需要加break,不加就死，但是yield自动返回
int num = switch (choice) {
	case 1,2 : {
		System.out.print("我赢");
		yield 6;
	} 
	case 3 : yield 7;
	default : yield 8;
}
switch (choice) {
	case 1,2 : {
		System.out.print("我赢");
		num = 6;
		break;
	} 
	case 3 : num = 7;break;
	default : num = 8;
}
//注意，在switch中不能使用return break continue ，有需求就用yield
//当你复习到这里，能够理解这里的四种switch，其实就很强了
//对于加注解， 这个不做要求
```
##### 大数
``` java
import java.math.BigInteger,BigDecimal;

BigInteger a = BigInteger.valueOf(100);
BigInteger reallybig = BigInteger.valueOf("222222222222222222222222222222222222222222222222222222");
a.add(a);
a.multiply(a);
a.sqrt();
a.mod(a);
a.divide(a);
a.compareTo(a); //比较返回结果是int 的 0 或者正负数

```
>在旧 Java（JVM 编译为 tabelswitch/lookupswitch）中：
switch 对小整数范围最快（O(1) 查表）
switch 对稀疏值用二分查找（O(log n)）
if else 是顺序判断（O(n)）
这个知识点绝对是阴间了
但是，现代JVM已经优化的很好了，没什么区别。
这些阴间的知识点还是不要上桌了

![alt text](/img/java/image.png)
##### 数组
``` java
//java对你的数组很宽限
int[] a = {
	1001,
	1111,
}//你多了一个逗号，java是允许的
//匿名函数优化
smallPrimes = new int[] {17,16,15};
//等价于
int[] temp = {17,16,15};
Primes = temp;
//java允许长度为0的数组
new ele[0]
new ele[] {}
//以上都是length为0 的数组，但不是null
```
``` java
//for each 拯救遍历
for(n : num) {}


//Java中一般的赋值都是浅拷贝
//如果要深拷贝
newarr = Arrays.copy(oldarr,2*oldarr.length)

//排序
import java.util.Arrays

Arrays.sort(num);  //底层是优化了的快速排序
Arrays.binarySearch(T[] t,T t1);
Arrays.binart
```

>这里我们需要补充一点，java有了foreach，为什么还要Iterator，以及，這两者有什么区别？
实际上，java中的for each 底层是依赖于Iterator的；
第二，for each有很多的受限，比如，for each内部几乎无法停止，无法删除某一个元素(报错)
所以，for each只是一个简化工具
另外，对于自己创建的Object类，没有实现Iterator接口，就无法使用for each

##### 命令行参数
String[] args ，命令行参数存储在args
``` bash
java Message -h world
# java中会存储 -h 为 args[0]
# 记住，Message不会被存储
```
### 第四章 对象与类

**java中所有对象都在堆中**

##### LocalDate类
 ``` java
LocalDate now = LocalDate.now();
LocalDate date = LocalDate.of(2020, 1, 1);
int year = date.getYear();
int month = date.getMonthValue();
date = now.plusDays(1000);
System.out.println(date);
 ```
#####  java类的“须知”
* 构造器

``` java
//在构造器里面，我极其推荐你去使用null引用
public ClassName(Type1 param1,Type2 param2){
	this.field1 = Objects.requireNonNullElse(param1,"unknow");
	this.field2 = Objects.requireNonNull(param2," field2 can be null ");
}

```

* 推荐使用var

``` java
//在c++中，很多程序员诟病总是需要同时维护.h 和 .cxx 
// 在java中，你也被强制写 new 类名()
AcomplexClassName acomplexclassexample = new AcomplexClassName(param1,param2);
//这种感觉和C++程序员一样头大
//在臃肿的c++中，都支持下面写法
AcomplexClassName example(param1,param2);
//但是java不支持

//在jdk 10 中，java添加了var关键字，算是省了一半力气吧
var example = new AcomplexClassName(param1,param2);

//所以，无论如何，我都推荐你写var
//但是，我建议你不要乱用,尤其对于数值型
var  intnum = 1000L
var tinynum = 1000.3f
//你要是写出上面的代码，你就等死吧

//此外，var只允许生命局部变量
```
* 莫名其妙的get,set

``` java
//对于初学者，可能对于setters和getters感到莫名奇妙，不过，大家都是从新手过来的。
//对于类的一切field，都建议你设置为  private
//想要查值或者想要重新赋值，都必须通过一个暴露的方法
//禁止对field直接进行操作
```

* 4.3.8

>先留着

* final 的 使用

``` java
private final StringBuilder evaluations;
evaluations = new StringBuilder;

evaluations.append()
//上面这个final仅仅用来修饰StringBuilder的指针，所以，
//对于一些可变类型要   慎 用！！！ 
```

* static 

``` java
//有一些人认为，静态字段应该被叫为“类字段”
class Employee{
	static int All_id = 1;
}
//声明之后，这个方法属于整个类，在类创建的时候就已经确定了


//之前说，不建议有公共字段，但被final的字段可以是公共的，因为已经不可改了
```

##### 工厂方法
>从前面可以看出来，构造器是有弊端的，比如我不能给构造请命名，我不能让构造器返回一个其他对象
等等限制，所以有了工厂方法（ factory method ）
 

##### Java总是采用按值调用
java中方法会得到所有参数值的一个副本，方法不能修改传递给它的任何参数变量的内容
>这一点你会意识到java和众多语言不同的地方
在C++中，允许你传入指针，允许你传入引用···但是在java里，函数永远只会拿到一份拷贝信息 

>可能会有人疑惑，java的方法如果传入一个对象，他们发现，对象仍旧可以修改。
因此，有人认为，java对对象采用的是按照引用调用。
实际上，这是错的
java的方法得到的是一份副本，只不过这个副本和原本的类名指向了同一个对象
下面将进行举例说明
``` java
public static void swap(Class a,Class b){
	Class temp = a;
	a = b ;
	b = temp ;
}
//如果java采用引用传递，那么a，b就可以交换
//但实际上，Java使用的是值传递
//底层相当于
public static void swap(Class a,Class b){
	Class x = a;
	Class y = b; 
	Class temp = x;
	x = y ;
	y = x ;
	//丢弃x，y
}
//所以当然不会对原值有任何影响。 
```
 
##### 构造器
* 重载

>对于方法，构造器(构造方法)，都允许重载。
java依靠签名来分辨不同的方法
``` java
indexOf(int,int)
indexOf(String,int)
index(int)
//可见，签名只与函数名和参数有关，跟返回值无关
int getA(int)
double getA(int)
//如果写出上面的只有返回值不同，那就很逆天了
```
* 初始化

>java中，对于构造器，如果你没有显示（传参数）初始化所有字段，会自动赋值默认值，(0,false,null)
* 无参构造器
>如果你不写构造器，java会帮你写一个无参构造器
如果你写了，java就不会帮你实现无参构造器了
##### this
>java中的this甚至能使用其他构造器
``` java
public Class(double s){
	this("renji",s);
}
```
我们主要想说的就是构造器的两种不同习惯
``` java
public Class(String name, int age){
	this.name = name ;
	this.age = age;
}

public Class(String aName,int aAge){
	name = aName;
	age = aAge;
}

//你更喜欢哪一种方式呢？
```

##### 初始化块
>java初始化字段的方式还有第三种！
1.构造器赋值
2.声明中赋值
3.在初始化块赋值
不论是普通代码块还是静态代码块，在实际开发中需求并不是很大
这里有一个同步代码块的概念，与线程有关，以后可能会遇到

##### 析构函数 
这里后面会详细涉及到jvm的垃圾处理机制，
不过，这里还是要提前说明一下，对于finalize，这个方法已经被废弃了，请不要使用

##### 记录
java干什么都要new 一个类，然后写上getters，setters，然后构造器，tostring

想象一下，假如你只想定义一个Point，但是莫名奇妙就得写上面的一大堆，还是人类吗？还有人类吗？

所以在JDK14，引入了记录这个东西，最终在JDK16中发布
``` java
record Point(int x, int y) {}

//相当于
final class Point extends Record {
    private final int x;
    private final int y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
	//这里可能会感到有点奇怪
	//但java就是这么处理的，不适用getter， setter
	//而是使用这样的一个字段函数
    public int x() {
        return this.x;
    }

    public int y() {
        return this.y;
    }

    public String toString() {
        return String.format("Point[x=%s, y=%s]", x, y);
    }

    public boolean equals(Object o) {
        ...
    }
    public int hashCode() {
        ...
    }
}

//要记住这里，字段是private final的
//不能直接去访问

```
##### java的包
>在java中，import还是挺好用的
但java中其实还有一个静态导入的东西，比如：
import java.util.System.*
这样之后，你就可以
out.print()
put.exit()

##### java一些原生工具
* jar包

``` bash
jar cfm app.jar manifest.mf *.class
java -jar app.jar
```
* javadoc文档注释

``` bash
javadoc -encoding UTF-8 -charset UTF-8 -d doc Main.java
```
* 打包TankGame

``` bash
#javac编译
javac -encoding UTF-8 *.java
#创建指定文件
touch manifest.txt
# 注明：Main-Class: Main   如果有包名，还得写包名 hzy.Main 
#注意要留一行空行，不然是非法的

# 打jar包
jar cfm tankgame.jar manifest.txt *.class

#打包为exe
jpackage --name TankGame --app-version 1.0.1 --input build --main-jar tankgame.jar --main-class TankGame --type exe --icon favicon.ico --win-dir-chooser
# --name 最终exe的名字
# --input 指向jar所在目录
# --main-jar 指定jar
# --main-class 指定主类名
# --type 指定安装程序
# --icon 指定图标
# --win-dir-chooser自定义安装目录
```
上面的操作没有指定目录，可能会很乱

下面给一个gpt的
``` bash
@echo off
echo ===== 清理旧文件 =====
rmdir /s /q build 2>nul
rmdir /s /q dist 2>nul

echo ===== 创建目录 =====
mkdir build\classes
mkdir dist

echo ===== 编译 Java 源码 =====
javac -encoding UTF-8 -d build\classes src\*.java

echo ===== 生成 MANIFEST 文件 =====
echo Main-Class: Main > build\manifest.txt
echo. >> build\manifest.txt

echo ===== 打包 JAR =====
jar cfm build\tankgame.jar build\manifest.txt -C build\classes .

echo ===== 打包 EXE（需要 WiX） =====
jpackage ^
  --name TankGame ^
  --input build ^
  --app-version 1.0.1 ^
  --main-jar tankgame.jar ^
  --main-class Main ^
  --type exe ^
  --icon assets\favicon.ico ^
  --dest dist
  --win-dir-chooser
echo ===== 完成！！！ =====
echo JAR 生成于：build\tankgame.jar
echo EXE 安装包生成于：dist\TankGame.exe
pause

```
>这个东西说的太久了，我慢慢又找出了一套技术栈，既然这个这么好用，那我们直接使用javaFx开发一个桌面端系统其实也是不错的

##### 注释
* javadoc

>会用这个，那我承认你是个高手

* 类注释

> /**
	这个就很好用
 */

* 方法注释

* 字段注释

* 通用注释

* 包注释

### 第五章

##### 继承
``` java
public class Manager extends Employee{

}

//阻止继承
public final class Massager{

}
//阻止覆写
public final String getName(){

}

//向上转型（Upcasting）：一定安全，不需要强转
Animal a = new Dog();

//向下转型（Downcasting）：必须满足“真实类型是目标类或其子类”
Animal dog = new Dog();
Dog a = dog;
if(dog instanceof Animal)  //true
```
##### 访问权限
* public
* protedted //只允许子类和同包访问
* private //只能自己用

##### equal()
>在我们重写equals的时候，会纠结于
到底使用 instanceof 还是 .getClass()进行判断

``` java
//最标准的步骤

//判断二者是否相同 
if(this == otherobj ) return true;
//判断是否非空
if(otherobj ==  null) return false;
//判断是否有相同语义来进行选择getClass和instanceof
	//相同语义
	if(!otherobj instanceof ThisClss obj) return false;
	//这句可能有点不理解,JDK16+,比较otherobj是否是thisClass,是的话,把otherobj转为obj(ThisClass类)
		// 执行对字段的判断
	//不同语义
	if(!this.getClass() == otherobj.getClass())  return false;
	otherobj = (ThisClass) otherobj;
		// 执行对字段的判断


//Object的equals方法十分简单
public Object equals(Object obj){
	return this == obj;
}
//所以,必须自己重新equals方法,不然和==没什么区别

```
##### hashCode()
``` java
//hashCode定义在Object类
//也就是说,所有对象都有hashcode,对于一些对象,底层重写了此方法
//比如String
String s = "sb" ;
String b = "sb" ;
Sout(s.hashCode() == b.hashCode())

//对于有多个字段
return Objects.hashCode(obj1,obj2);
```
##### toString()
``` java
@Override
    public String toString() {
        return "Student{" +
                "value=" + value +
                ", age=" + age +
                '}';
    }

//在我们调用toString方法的时候
//建议写法
sout(""+ x);
//而不是
sout(x.toString())

//这样写的好处是，如果x是一个基本类型，这个语法仍然不报错""+x
//其实也可以
sout(x)


System.out.println(student);
System.out.println(student+"");
System.out.println(student.toString());
```

##### 标准写法
``` java
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false; //这个的作用是什么？为了比较公有字段
        Student student = (Student) o;
        return age == student.age;
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(age);
    }

    @Override
    public String toString() {
        return "Student{" +
                "value=" + value +
                ", age=" + age +
                '}';
    }
```
##### 基本类型的包装类
首先我们来探究一个好玩的东西，自动拆箱装箱
``` java 
public  void  add(Integer i){
	i++;
}
```
这个函数有效果吗？
答案是没有，为什么呢？

>首先第一点，我们之前说过基本类型的包装类的底层是一个value字段
private final int value;
无法更改，那么Interger++时，值又是怎么变化的呢？

``` java
//底层实现 i++
	//自动拆箱
	int i = i.intValue();
	i++;
	//自动装箱
	Integer new_i = Integer.valueOf(tmp);
	i = new_i;
//由于java总是值拷贝，我们传参i，在函数内部其实是i_copy
//也就是，在函数内部：
	i_copy = new_i ;
	//与我们的i没有任何关系，所以······
```
``` java
//常用方法
int a = Integer.parseInt("10086");
int a_2 = Integer.parseInt("100010",2);

Integer c = Integer.valueOf("10086");
Integer c_2 = Integer.valueOf("100110",2);

//如果你不够熟悉方法，就可能不知道下面这几个是什么类型的
var a = Integer.parseInt("10086");
var a_2 = Integer.parseInt("100010",2);

var c = Integer.valueOf("10086");
var c_2 = Integer.valueOf("100110",2);

//toString()方法默认使用10进制，想使用其他进制和上面的方法一样，给一个radix
```
##### 可变参数
``` java
@Test
public void try2(){
	deal_int(1,2,3,4,5);
	deal_int2(new int[]{1, 2, 3, 4, 5} );
}


public void deal_int(int... vales){
	int temp = Integer.MIN_VALUE;
	for(int i : vales){
		temp = (i > temp) ? i : temp;
	}
	System.out.println(temp);
}
public void deal_int2(int[] vales){
	int temp = Integer.MIN_VALUE;
	for(int i : vales){
		temp = (i > temp) ? i : temp;
	}
	System.out.println(temp);
}
```
##### 抽象类与抽象函数
* 抽象类可以没有抽象函数
* 有抽象函数一定是抽象类
* 抽象类不可以被实例化，即不能被new
* 抽象类可以做对象变量
``` java
public abstract class Person{
	public abstract String getDescription(){

	}
}

```
##### 枚举类
``` java
public class test01 {
    public static void main(String[] args) {
        String s = "SMALL";
        Size size = Size.valueOf(s);
        System.out.println(size);
        System.out.println(size.getValue());

		System.out.println(size.ordinal());
        System.out.println(size2.ordinal());
        
        //这个函数比较两个的ordinal,返回一个int
        System.out.println(size.compareTo(size2));
    }
}

enum Size{
    SMALL("S"),LARGE("L");

    private  Size(String value) {this.value = value;}
    public String getValue(){
        return  value;
    }
    private String value;
}
```
##### 密封类
``` java
public abstract sealed class Test2 permits Json1,Json2 {
    
}

    final class Json1 extends  Test2{
    
}

    sealed  class  Json2 extends  Test2{
        
    }
    
    final   class  Json22 extends  Json2{
    
    }
```
![alt text](/img/java/image3.png)

##### 反射(框架的灵魂)
``` java
@Test
public void stage1() throws ClassNotFoundException, NoSuchMethodException, InvocationTargetException, InstantiationException, IllegalAccessException {
	Person p = new Person();
	Student s = new Student();
	System.out.println(s.getClass()); //class aaa.Student
	System.out.println(Student.class); //class aaa.Student
	System.out.println(s.getClass() == Student.class); //true
	String s1 = "aaa.Person";


	Class cl = Student.class;
	Class cl2 = Class.forName(s1);
	Constructor perBuilder = cl2.getConstructor();

	Object po = perBuilder.newInstance();
	Person p2 = (Person) perBuilder.newInstance();

	System.out.println(po.hashCode() + " " + p2.hashCode()); //226170135 381707837
}
```
>在我们之前Tankgame的开发中，最后打jar包时候，那些FileReader什么的都报错。
(虽然是代码功底问题，但是有更好的方法)
这里提供一个"resource"类

``` java 
public class Resource {
    public static void main(String[] args) {
        Class cl = Resource.class;
        URL url = cl.getResource("img/1.jpg");
        //使用类.getResource()，会从类的位置找资源，非常方便
        var img = new ImageIcon(url);

        System.out.println(url); //会输出路径
        System.out.println(img);
    }
}

//我们还可以用resource目录，将其设置为Resource Root
//然后直接
getResource("/...")
```
提供一个比较专业的Resource类
``` java
import javax.swing.*;
import java.net.URL;

public final class Resources {

    public static final ImageIcon PLAYER_ICON;
    public static final ImageIcon BACKGROUND_ICON;
    public static final ImageIcon LOGO_ICON;

    static {
        PLAYER_ICON = load("/img/player.png");
        BACKGROUND_ICON = load("/img/background.jpg");
        LOGO_ICON = load("/img/logo.png");
    }

    private Resources() {
        //禁止 new，真正的工具类
		//如果你想问，final类不是不能new吗，为什么还要给构造器
		//如果你不给构造器，默认有public无参构造器，实际上是可以new Resource()，只不过会报错
		//但是我们给一个private的无参构造器，甚至没有字段提示，所以就不可能不小心写出new的代码了
    }

    private static ImageIcon load(String path) {
        URL url = Resources.class.getResource(path);
        if (url == null) {
            throw new IllegalArgumentException("资源未找到: " + path);
        }
        return new ImageIcon(url);
    }
}

```
