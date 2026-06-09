---
layout:     post
title:      "Design Patterns"
subtitle:   " \"我得学设计模式\""
date:       2026-1-28 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Java
---


 

### 两阶段中止模式

* 也可以使用volatile


## 同步模式
### 保护性暂停

用在一个线程等待另一个线程的执行结果

* 需要关联同一个`GuardedObject`，实现一个结果从一个线程传递到另一个线程
* 如果有结果源源不断从一个线程传递到另一个线程，那么就需要使用到消息队列
* JDK中join future的实现就是使用这种模式

``` java
class GuardedObject{
    Object response;
    public synchronized Object get(long timeout) throws InterruptedException {
        long begin = System.currentTimeMillis();
        long passtime = 0;
        while(response == null){
            long waittime = timeout - passtime;
            if (waittime<=0) break;
            wait(waittime);
            passtime = System.currentTimeMillis()-begin;
        }
        return response;
    }

    public synchronized void set(Object response){
        this.response = response;
    }
}

```

### 生产者消费者

``` java
class MsgQueue{
    private int capcity;
    private LinkedList<Message> list = new LinkedList<Message>();

    public MsgQueue(int capacity){
        this.capcity = capacity;
    }

    public Message take(){
        synchronized(list){
            while(!list.isEmpty()){
                try {
                    list.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
        Message message = list.removeFirst();
        list.notifyAll();
        return message;
    }

    public void put(Message msg){
        synchronized(list){
            while(list.size()==capcity){
                try {
                    list.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
        list.add(msg);
        list.notifyAll();
    }
}

final class Message{
    private int id;
    private Object value;

    public int getId() {
        return id;
    }

    public Object getValue() {
        return value;
    }
}

```


### 顺序控制

实现T2的结果在T1之后

* wait-notify
* park-unpark
    * 直接做成许可证式
    * 有点离奇
* ReentrantLock

### 交替输出 


* wait-notify

    ``` java
    public class Test26 {
        public static void main(String[] args) {
            WaitNotify waitNotify = new WaitNotify(1,5);
            new Thread(()->{
                waitNotify.print("a",1,2);
            }).start();
            new Thread(()->{
                waitNotify.print("b",2,3);
            }).start();
            new Thread(()->{
                waitNotify.print("c",3,1);
            }).start();

        }
    }

    class WaitNotify {
        private int flag;
        private int loop_count;

        public WaitNotify(int flag, int loop_count) {
            this.flag = flag;
            this.loop_count = loop_count;
        }

        public void print(String str,int waitFlag,int nextFlag){
            for (int i = 0; i < loop_count; i++) {
                synchronized (this) {
                    while (flag != waitFlag) {
                        try{
                            this.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    System.out.println(str);
                    flag = nextFlag;
                    this.notifyAll();
                }
            }
        }

    }
    ```
* await-signal

    ``` java
    public class Test27 {
        public static void main(String[] args) {
            AwaitSignal awaitSignal = new AwaitSignal(5);
            Condition a = awaitSignal.newCondition();
            Condition b = awaitSignal.newCondition();
            Condition c = awaitSignal.newCondition();

            new Thread(()->{
                awaitSignal.print("a",a,b);
            }).start();
            new Thread(()->{
                awaitSignal.print("b",b,c);
            }).start();
            new Thread(()->{
                awaitSignal.print("c",c,a);
            }).start();


            awaitSignal.lock();
            a.signal();
            awaitSignal.unlock();
        }
    }


    class AwaitSignal extends ReentrantLock {
        private int loopNumber;

        public AwaitSignal(int loopNumber) {
            this.loopNumber = loopNumber;
        }

        public void print(String str, Condition current,Condition next) {
            for (int i = 0; i < loopNumber; i++) {
                lock();
                try{
                    current.await();
                    System.out.print(str);
                    next.signal();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }finally {
                    unlock();
                }
            }
        }
    }
    ```
* park-unpark

    ``` java
    public class Test28 {
        public static void main(String[] args) {
            ParkUnPark parkUnPark = new ParkUnPark(5);

            Thread[] threads = new Thread[3];

            threads[0] = new Thread(() -> {
                parkUnPark.print("a", threads[1]);
            }, "t1");

            threads[1] = new Thread(() -> {
                parkUnPark.print("b", threads[2]);
            }, "t2");

            threads[2] = new Thread(() -> {
                parkUnPark.print("c", threads[0]);
            }, "t3");

            threads[0].start();
            threads[1].start();
            threads[2].start();

            LockSupport.unpark(threads[0]);
        }
    }

    class ParkUnPark {
        private final int loopNumber;

        public ParkUnPark(int loopNumber) {
            this.loopNumber = loopNumber;
        }

        public void print(String str, Thread next) {
            for (int i = 0; i < loopNumber; i++) {
                LockSupport.park();
                System.out.print(str);
                LockSupport.unpark(next);
            }
        }
    }
    ```



### 犹豫模式
想让某件事情只做一次
* 只用volatail不行
    * 不能保证原子性
* 可以使用synchronized

### 单例模式

#### 饿汉式

* 加final
    * 害怕子类覆盖方法
* 如何防止反序列化破坏单例
    * 重写 readResovle()方法
* 设置私有
    * 防止别人new
    * 但不能防止反射
* static final  = new 
    * 是线程安全的
* 为何提供get方法，而不是直接给成员变量
    * 可以使用泛型

#### 枚举实现

* 是否为单例
    * 是
* 没有并发问题 
* 不能被反射破坏单例
* 不能被 反序列化 破坏单例
* 枚举单例是 饿汉式
* 初始化可以用方法

#### 懒汉式

* double-check
    * 降低锁的粒度

* 基于静态内部类
    * 只有用到才会触发类的加载



### 享元模式
* 对对象进行重用

``` java
@Slf4j
class Pool{
    private final int poolSize;

    private Connection[] connections;
    private AtomicIntegerArray states;

    public Pool(int poolSize) {
        this.poolSize = poolSize;
        this.connections = new Connection[poolSize];
        this.states = new AtomicIntegerArray(new int[poolSize]);
        for (int i = 0; i < poolSize; i++) {
            connections[i] = new MockConnection();
        }
    }

    public Connection borrow(){

        do {
            for (int i = 0; i < poolSize; i++) {
                if (states.get(i) == 0){
                    if(states.compareAndSet(i, 0, 1)) return connections[i];
                }
            }
            //
            synchronized (this) {
                try {
                    this.wait();
                } catch (InterruptedException e) {
                   e.printStackTrace();
                }
            }
        }while(true);
    }

    public void free(Connection con){
        for (int i = 0; i < poolSize; i++) {
            if (connections[i] == con){

                states.set(i, 0);
                synchronized (this) {
                    log.debug("归还连接 {}",con);
                    this.notifyAll();
                }
                break;
            }
        }
    }
}
```

* 上面这个代码会有lost notification 的风险
    * 如果检查到第m个状态(m < n),但是m前面有con被释放
    * 这时候notify谁也不会打断，线程wait()之后没人来打断他


