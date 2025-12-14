---
layout:     post
title:      "How old are you, Java"
subtitle:   " \"java和我的爱恨情仇\""
date:       2025-12-10 12:00:00
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


//函数式接口
Arrays.sort(arr,(first,second)->first.length() - second.length());

// 为什么这么写？
public class Test06 {
    public static void main(String[] args) {
        LocalDate day = LocalDate.of(2025,1,1);
        LocalDate hireDay = Objects.requireNonNullElse(day,LocalDate.of(1970,1,1));
        //上面这个new的代码无论如何都会执行，浪费资源



        LocalDate hireday = Objects.requireNonNullElseGet(day , () -> LocalDate.of(1979,10,1));
        //这个仅当day为null时候，才会调用到new

        //体现出了函数式接口的好处
    }
}


//方法引用
var timer = new Timer(100,event -> System.out.println(event));
var timer = new Timer(1000, System.out::println);
//这两种写法都很好,上面是lambda，下面是方法引用
 ```
* object::instanceMethod

>public class Test06 {
    public static void main(String[] args) {
        Runnable run = System.out::println;
        run.run();
    }
}

其实这里还有一些说法，比如，println是哪个？因为我们重载了很多println，底层会自己选一个合适的
这里这个run选的是直接打印空行，
* Class::instanceMethod

>Arrays.sort(strs, String::compareToIgnoreCase);
* Class::staticMethod 

>Math::pow  
等价于: (x,y) -> Math.pow(x,y)

其实上面这多方法，区别也就是调用关系，
.(x) x.(y) .(x,y)

``` java
separator::equals    x -> separator.equals(x)
String::trim    x -> x.strip()
String::concat    (x,y) -> x.concat(y)
Integer.valueOf   x -> Integer.valueOf(x)
Integer.sum    (x,y) -> Integer.sum(x,y)
String::new     (x) -> new String(x)
String[]::new   n -> new String[n]
```
##### 使用场景
``` java
list.forEach(System.out::println);

List<String> trimmed = list.stream()
    .map(String::trim)
    .toList();

Collections.sort(users, Comparator.comparing(User::getName));

list.stream()
    .filter(separator::equals)
    .toList();

String[] arr = list.toArray(String[]::new);

```
Java 中，Lambda 只能捕获 “final 或 effectively final” 的变量。
java也有闭包！！！
``` java
public class Test06 {
    public static void main(String[] args) {
        String text = "aaa";
        for (int i = 0; i < 10; i++) {
            ActionListener listener = event -> {
                System.out.println(i + "" + text );//报错，i捕捉不到
            };
        }
         
    }
}
```

##### 处理lambda表达式
``` java
public class Test06 {
    public static void main(String[] args) {
         repeat(10,(i) -> System.out.println("this is the "+i+" try"));

    }
    public static  void repeat(int n, IntConsumer action){
        for (int i = 0; i < n; i++) action.accept(i);
    }
}
```
常见函数式接口,重点！！！！！
 
 | 函数式接口                   | 参数类型 | 返回类型    | 抽象方法名  | 描述（用途）                     |
| ----------------------- | ---- | ------- | ------ | -------------------------- |
| **Runnable**            | 无    | void    | run    | 执行一个任务，无参无返回值              |
| **Supplier<T>**         | 无    | T       | get    | 提供/生产一个 T（工厂、懒加载）          |
| **Consumer<T>**         | T    | void    | accept | 消费一个 T（打印、保存、处理）           |
| **BiConsumer<T, U>**    | T, U | void    | accept | 同时消费两个参数（Map.forEach 常用）   |
| **Function<T, R>**      | T    | R       | apply  | 把 T 转成 R（类型转换、映射）          |
| **BiFunction<T, U, R>** | T, U | R       | apply  | 接收两个值 T, U 转成 R（组合、计算）     |
| **UnaryOperator<T>**    | T    | T       | apply  | 接收一个 T，返回一个 T（自我转换，如 trim） |
| **BinaryOperator<T>**   | T, T | T       | apply  | 接收两个 T，返回一个 T（求和、合并、最大值）   |
| **Predicate<T>**        | T    | boolean | test   | 判断一个条件是否成立（过滤）             |
| **BiPredicate<T, U>**   | T, U | boolean | test   | 判断两个值是否满足条件                |

| 接口名称                  | 参数类型     | 返回类型    | 抽象方法名      | 描述                     |
| --------------------- | -------- | ------- | ---------- | ---------------------- |
| **IntSupplier**       | 无        | int     | getAsInt   | 提供一个 int               |
| **IntConsumer**       | int      | void    | accept     | 消费一个 int               |
| **IntPredicate**      | int      | boolean | test       | 判断条件（int 过滤）           |
| **IntFunction<R>**    | int      | R       | apply      | int 转对象 R              |
| **IntUnaryOperator**  | int      | int     | applyAsInt | int → int（一元运算，如 i+1）  |
| **IntBinaryOperator** | int, int | int     | applyAsInt | int → int（二元运算，如 sum）  |
| **ToIntFunction<T>**  | T        | int     | applyAsInt | 对象 T → int（用于排序、求长度）   |
| **ObjIntConsumer<T>** | T, int   | void    | accept     | 消费对象 T 和 int（Map 处理常用） |

| 接口名称                   | 参数类型       | 返回类型    | 方法名         | 描述          |
| ---------------------- | ---------- | ------- | ----------- | ----------- |
| **LongSupplier**       | 无          | long    | getAsLong   | 提供 long     |
| **LongConsumer**       | long       | void    | accept      | 消费 long     |
| **LongPredicate**      | long       | boolean | test        | 条件判断        |
| **LongFunction<R>**    | long       | R       | apply       | long → R    |
| **LongUnaryOperator**  | long       | long    | applyAsLong | long → long |
| **LongBinaryOperator** | long, long | long    | applyAsLong | long → long |
| **ToLongFunction<T>**  | T          | long    | applyAsLong | T → long    |
| **ObjLongConsumer<T>** | T, long    | void    | accept      | 消费 T 和 long |

| 接口名称                     | 参数类型           | 返回类型    | 方法名           | 描述              |
| ------------------------ | -------------- | ------- | ------------- | --------------- |
| **DoubleSupplier**       | 无              | double  | getAsDouble   | 提供 double       |
| **DoubleConsumer**       | double         | void    | accept        | 消费 double       |
| **DoublePredicate**      | double         | boolean | test          | 条件判断            |
| **DoubleFunction<R>**    | double         | R       | apply         | double → R      |
| **DoubleUnaryOperator**  | double         | double  | applyAsDouble | double → double |
| **DoubleBinaryOperator** | double, double | double  | applyAsDouble | double → double |
| **ToDoubleFunction<T>**  | T              | double  | applyAsDouble | T → double      |
| **ObjDoubleConsumer<T>** | T, double      | void    | accept        | 消费 T 和 double   |

······接口太多了，遇到自己查吧

``` java
//对于我们实现的函数接口，如果我们担心后来的开发者添加其他函数
//使用注解标注
@FunctionalInterface
```

##### 内部类
这个的使用场景还真的比较少
内部类的好处就是拿到的权限比较多，其他的并没有什么了
``` java
public class Order {

    private String orderId;
    private double discount; // 外部类中的折扣

    public Order(String orderId, double discount) {
        this.orderId = orderId;
        this.discount = discount;
    }

    // 普通内部类
    public class OrderItem {
        private String product;
        private double price;

        public OrderItem(String product, double price) {
            this.product = product;
            this.price = price;
        }

        public double getFinalPrice() {
            // 内部类可以直接访问外部类实例的字段
            return price * (1 - discount);
        }

        public void print() {
            System.out.println("Order: " + orderId + ", Product: " + product + ", Final price: " + getFinalPrice());
        }
    }
}

```
##### 局部内部类
例如，在方法中创建类，不能加访问修饰符，默认只在方法中可见，其他任何地方都无法访问
局部内部类甚至像是一个代码块，可以访问局部变量(事实最终面量)
``` java
public int process(int[] data) {

    class Counter {
        int countPositive() {
            int count = 0;
            for (int x : data) if (x > 0) count++;
            return count;
        }
    }

    return new Counter().countPositive();
}

```
##### 匿名内部类
匿名内部类没有类名，直接new一个超类或者接口 
匿名内部类没有构造器，但是可以有初始代码块
``` java
//双括号技巧
new ArrayList<String>(){{add("harry")}};
//这里实现一个匿名内部类，并在类里面放上初始代码块

// 对于匿名子类,使用getClass() 判断是否相同可能会出错
//每一个匿名内部类都会生成一个新的编号。
//所以建议用instanceOf判断接口类型相同
```
##### 静态内部类
``` java

```

//上面这些内部类感觉学的还是有点糊涂

##### 服务加载器

##### 代理
使用代理进行一些操作，尽管我没有定义这些操作，我仍然能
``` java
public class TraceHandler implements InvocationHandler {
    private Object object;

    public TraceHandler(Object object) {
        this.object = object;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        //进行一系列操作
        return null;
    }
}

```

``` java
UserService target = new UserServiceImpl();

InvocationHandler handler = (proxy, method, args) -> {
    System.out.println("调用前: " + method.getName());
    Object result = method.invoke(target, args); // 调用真实对象的方法
    System.out.println("调用后: " + method.getName());
    return result;
};

UserService proxy = (UserService) Proxy.newProxyInstance(
        target.getClass().getClassLoader(),
        target.getClass().getInterfaces(),
        handler
);

proxy.login("Tom");

```

### 异常，断言和日志
##### 处理错误
* Throwable
    * Error
    * Exception
        * RuntimeException
        * other Exception

一个小例子，自己创建异常类，并抛出
``` java
public class Test07 {
    public static void main(String[] args) throws MyCreateException {
        var e = new MyCreateException("我是一只猫咪");
        throw e;
        // Exception in thread "main" Test.Test07$MyCreateException: 我是一只猫咪
    }
    static class MyCreateException extends Exception{
        public MyCreateException() {
        }

        public MyCreateException(String message) {
            super(message);
        }
    }
}

//java.lang.Throwable
Throwable();
Throwable(String message);
String getMessage();
```
##### 异常捕获
* try-catch-finally
* 多catch
* 异常链
* try-with-resource

``` java
     try {
            int a = 1/0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        
//子类重写方法时，throws 列表只能“变少或变窄”，不能“新增或变宽”。
//但是RuntimeException不受印象，因为一个是在编译期检查，一个是在运行中抛出异常

class Parent {
    void test() throws IOException {}
}

class Child extends Parent {
    @Override
    void test() throws SQLException {} // 编译错误
}

// 捕获多个异常
try {
    new FileInputStream("not_exist.txt");
} catch (FileNotFoundException e) {
    System.out.println("文件不存在");
} catch (IOException e) {
    System.out.println("IO 异常");
}

//异常合并捕获
try {
    // 可能抛 IOException 或 SQLException
} catch (IOException | SQLException e) {
    // 合法：两者无继承关系
    // 如果是catch (FileNotFoundException | UnknownHostException e)那就不合法
}

//异常链
try {
            new FileInputStream("not_exist.txt");
        } catch (FileNotFoundException original) {
            var e = new IOException("file io error");
            e.initCause(original);
            throw e;
        //Exception in thread "main" java.io.IOException: file io error
            //	at Test.Test08.main(Test08.java:19)
            //Caused by: java.io.FileNotFoundException: not_exist.txt (系统找不到指定的文件。)
            //	at java.base/java.io.FileInputStream.open0(Native Method)
            //	at java.base/java.io.FileInputStream.open(FileInputStream.java:216)
            //	at java.base/java.io.FileInputStream.<init>(FileInputStream.java:157)
            //	at java.base/java.io.FileInputStream.<init>(FileInputStream.java:111)
            //	at Test.Test08.main(Test08.java:17)
        }
//通过在当前层捕获多个具体异常，
// 并统一转换为一个更高层的异常类型（异常链），
// 实现异常的“向上收敛”，
// 从而降低上层调用方的异常处理复杂度。

//try-with-resources
try(var in = new Scanner(Path.of("dfahkjf"))){
            //work with the res: "in"
        }//最后会自动执行流的关闭释放等操作
        
        //try-with-resource也可以有catch和finally语句
        //finally语句会在流关闭后执行

       
```
##### 常见api
``` java
//java.lang.Throwable
Throwable(Throwable cause);
Throwable(String message, Throwable cause);
Throwable initCause(Throwable cause);
Throwable getCause();
StackTraceElement[] getStackTrace();
void addSuppressed(Throwable t);
Throwable[] getSuppressed();

//java.lang.Exception
Exception(Throwable cause);
Exception(String message,Throwable cause);

//java.lang.RuntimeException
RuntimeException(Throwable cause);
RuntimeException(String message, Throwable cause);

//java.lang.StackWalker
static StackWalker getInstance();
static StackWalker gerInstance(StackWalker.Option option);
static StackWalker getInstance(Set<StackWalker.Option> options);
forEach(...) ;
walk(...);  //这两个方法过于复杂了

//java.lang.StackWalker.StackFrame



//java.lang.StackTraceElement


 
```
##### 使用断言
``` java
int x = 100;
assert x > 100 : x;
// Exception in thread "main" java.lang.AssertionError: 100  at Test.Test10.main(Test10.java:13)

//下面是一个用断言来作为假设文档，从而替代注释的写法
//这是一个很好的习惯，希望你保持
void transfer(Account from, Account to, int amount) {
    assert from != to : "from and to must be different accounts";
    assert amount > 0 : "amount must be positive";
    assert from.getBalance() >= amount : "balance must be sufficient";

    from.debit(amount);
    to.credit(amount);
}

```

##### 日志
``` java
Logger.getGlobal().setLevel(Level.OFF);
//关闭日志
int x = 101;
assert x > 100 : "x must be > 100, but was " + x;
Logger.getGlobal().info("大东北是我滴家乡");
//12月 13, 2025 4:36:22 下午 Test.Test10 main
//信息: 大东北是我滴家乡
final Logger mylogger = Logger.getLogger("Test.Test10");
mylogger.info("你就缺德");
//12月 13, 2025 4:39:13 下午 Test.Test10 main
//信息: 你就缺德
```
日志级别
* SEVERE
* WARING
* INFO
* CONFIG
* FINE
* FINER
* FINEST

``` java
final Logger mylogger = Logger.getLogger("Test.Test10");
mylogger.setLevel(Level.FINEST);
mylogger.fine("你就缺德");
//但是这样仍旧没法输出，原因是还需要配置处理器
mylogger.setUseParentHandlers(false);
var handler = new ConsoleHandler();
handler.setLevel(Level.FINEST);
mylogger.addHandler(handler);

mylogger.fine("我就是个超级dsb");

//扩展，除了ConsoleHandler
//还有 SocketHandler, iFleHandler
```
### 泛型程序设计
泛型的底层是使用继承实现的,
##### 泛型类与泛型方法
``` java
public class Pair<T> {
    private  T first;
    private  T second;

    public Pair(T first, T second) {
        this.first = first;
        this.second = second;
    }
    public Pair(){}

    ...setters
    ...getters


//调用泛型方法的时候，也可以在普通类中定义
//调用泛型方法的时候，注意要放到方法名前面
String middle = ArrayAlg.<String>getMiddle("john","a","a");


    public static void main(String[] args) {
        min("first", "second");

    }
    public static <T extends Comparable> T min (T ... a){//你可能会感到很奇怪，泛型统一使用extends
        //但是不会使用implements
        //其实原因是不想新增关键字，所以用了extends，这里的extends根继承和实现接口没有任何关系，仅仅只是一个新的含义”实现“
        if (a == null || a.length == 0) return null;
        T smallest = a[0];
        for(T t: a){
            if (smallest.compareTo(t)>0 ) smallest = t ;
        }
        System.out.println("the smallest is :  "+smallest);
        return smallest;
    }


//多个限定符
<T extends Comparabel & Serializable>;
//最多只有一个限定是类，但是可以有多个接口
// 第一个是类的限定

```
##### 泛型代码和虚拟机
``` java
//底层会进行类型擦除
//即所有的T都被Object代替,如果有初始限定类，就用限定类替代
<T extends Comparable & Serializable>;
//比如这个例子，底层先用Comparable替代，
// 仅仅只有当使用到Serializable的method的时候才会进行临时强转类型


//方法类型擦除带来了很多问题
//比如我们自己的方法与泛型的方法定义冲突了，这里介绍桥方法
// 一些情况中仅仅返回值不同，java中明显是不允许的

//例子
class Parent<T> {
    T get() {
        return null;
    }
}

class Child extends Parent<String> {
    @Override
    String get() {
        return "child";
    }
}



class Child extends Parent {

    // 你写的
    public String get() {
        return "child";
    }

    // 编译器生成的【桥方法】
    public Object get() {
        return get(); // 调用上面的 String get()
    }
}

//对于源码，方法标识 ：方法名 + 参数描述符 
//对于字节码：方法名 + 参数描述符 + 返回类型
//所以上面两个方法不冲突
```
##### 限制和局限性

1. 不能使用基本类型实例化类型参数

>List<int> list = new ArrayList<>(); // 编译错误
List<Integer> list = new ArrayList<>(); 

2. 运行时类型查询只适用于原始类型

>if (obj instanceof List<String>) { } // 编译错误

3. 不能创建参数化类型的数组

>List<String>[] arr = new List<String>[10]; // 编译错误

4. Varargs警告

>@SafeVarargs
static <T> void printAll(T... args) { }

5. 不能实例化类型变量

>public static <T> T create() {
    return new T(); // 编译错误
}

>public static <T> T create(Class<T> clazz) throws Exception {
    return clazz.getDeclaredConstructor().newInstance();
}       //替代方案

6. 不能构造泛型数组

>public static <T> T[] createArray(int n) {
    return new T[n]; // 编译错误
}

>public static <T> T[] createArray(Class<T> clazz, int n) {
    return (T[]) Array.newInstance(clazz, n);
}

7. 泛型类的静态上下文中类型变量无效

>class Box<T> {
    static T value; // 编译错误
}

8. 不能抛出或捕获泛型类的实例

>class MyException<T> extends Exception { } // 编译错误

9. 可以取消对检查型异常的检查

>public static <T extends Throwable> void sneakyThrow(Throwable t) throws T {
    throw (T) t;
}

10. 注意擦除后的冲突 
详细见上面桥方法

##### 通配符类型
为了解决一些问题
``` java
//我们想给一个方法传参
Pair<T extends Employee>;  //这种明显不怎么合适

Pair<? extends Employee>;//这样传就可以有很多不同Pair


//超类型限定
Pair<? super Employee>;  //传超类


public static <T> void copy(
        List<? super T> dest,
        List<? extends T> src) {

    for (int i = 0; i < src.size(); i++) {
        dest.set(i, src.get(i));
    }
}

//extends 解决“我想安全地读”
//super 解决“我想安全地写”


//<?> 和  <T>
boolean isEmpty(List<?> list)
void clear(List<?> list)
int size(List<?> list)
//以上的方法我不需要知道泛型的类型，我把它当成Object完全不会报错
//但是如果有需要知道类型的方法就需要使用T了


//通配符捕获和swapHelper
//这个东西的理解绝对有点问题，这个操作还是太神奇了
public static void swap(List<?> list, int i, int j) {
    swapHelper(list, i, j);
}

private static <T> void swapHelper(List<T> list, int i, int j) {
    T temp = list.get(i);
    list.set(i, list.get(j));
    list.set(j, temp);
}

```
##### 泛型与反射，依赖注入
``` java
public interface Factory {
    <T> T get(Class<T> type);
}


//举例子
public class SimpleContainer {

    private final Map<Class<?>, Object> singletons = new HashMap<>();

    public <T> T get(Class<T> type) {
        // 结束条件 1：单例缓存
        if (singletons.containsKey(type)) {
            return type.cast(singletons.get(type));
        }

        // 结束条件 2：不可注入类型
        if (type.isPrimitive() || type == String.class) {
            throw new IllegalStateException("Cannot autowire " + type);
        }

        try {
            Constructor<?> ctor = type.getDeclaredConstructors()[0];
            Parameter[] params = ctor.getParameters();

            Object[] deps = new Object[params.length];
            for (int i = 0; i < params.length; i++) {
                deps[i] = get(params[i].getType());
            }

            T instance = type.cast(ctor.newInstance(deps));
            singletons.put(type, instance); // 注册单例

            return instance;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

```

### 集合
##### 常见接口
* Collection 接口

``` java
public interface Collection<E>{
    boolean add (E element);
    Iterator<E> iterator();
}
```
* Iterator 接口

``` java
public interface Iterator<E>{
    E next();
    boolean hasNext();
    void remove();
    default void forEachRemaining(Consume<? super E> action);
}

```
* next() 与 remove()

>java中next永远是位于两个指针之间的位置，也就是说，调用next()，迭代器会从 1，2之间，跳到2，3之间，然后返回2的值，这时候调用remove，删除是迭代器前面的元素，也就是迭代器刚刚掠过的元素

* java.util.Collection<E>

``` java
Iterator<E> iterator(); //拿到迭代器
int size();
boolean isEmpty();
boolean contains(Object obj);
boolean containsAll(Collection<?> other);
boolean add(E element);
boolean addAll(Collection<? extends E> other);
boolean remove(Object obj);
boolean removeAll(Collection<?> other);
default boolean removeIf(Predicate<? super E> filter);
```

//先把上面跳过，我们直接进入重点
#### 具体集合
* ArrayList
* LinkedList
* ArrayDeque


``` java
//java.util.list<E>



//java.util.ListItetator<E>
```
##### LinkedList
这个比较重要的就是理清楚迭代器到底在哪个位置，这些api还是多用就会了
``` java


```
##### ArrayList | Vector
许多程序员喜欢使用Vector，这是因为在底层，ArrayList不是同步的，所以不够安全，但Vector是同步的，足够安全
但是对于一些不需要考虑同步异步的地方，直接用ArrayList

##### 散列表 HashSet
标准库中桶的大小初始为16，大小为2的幂，默认装填因子是0.75

##### 树集 TreeSet
TreeSet是有序的，底层实现是一个红黑树

##### 队列与双端队列 Queue Deque
java中的ArrayDeque,LinkedList 都实现了Deque的接口

你会发现，java中竟然没有实现栈！！！在早期，java是由栈的，继承于Vector，但是后来维护不好，废弃了。
而且从功能角度来说，java中的Deque已经可以完全替代Stack了，所以就没有Stack这个类了
##### 优先队列 PriorityQueue
底层是一个heap
##### 映射  HashMap  TreeMap
只要不需要有序，最好使用散列映射
##### 弱散列映射

##### 链接散列集与映射 LinkedHashSet  LinkedHashMap

##### 枚举集与映射 EnumSet

##### 标识散列映射 IdentityHashMap