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