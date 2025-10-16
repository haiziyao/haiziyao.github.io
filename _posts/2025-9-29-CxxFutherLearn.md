---
layout:     post
title:      "C++ futher learning"
subtitle:   " \"let us learn C++\""
date:       2025-09-29 05:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - C++
---

``` cpp
//mutable
class Example{
    public:
        int set_val const(int value){
            value = this.value;
        }
    private:
        mutable int value;
        //如果不加mutable，底层不允许在const中修改任何值，但是上面set_val就违反了，所以要加上mutable
}

//auto 
//extern  这个我记得之前用的就很少然后忘记了
//thread_local  线程局部存储

//mutable   特异功能缓存，延迟计算
    //这里简单介绍一下为什么会经常用到mutable
    //比如在很多函数里，都有get_val方法，很多情况下这个val是一个常量，为了避免某些操作val被改变了。
    //我们就可以使用 T get_val() const{}使用const修饰一下，这样就很轻松的保护了val
    //但是这时候又有了另外的需求，计算val的值需要耗费很多资源，所以我们不能在初始化这个类的时候就计算val
    //但是，也不能在get_val()里面计算，因为一来get_val()已经被const修饰了，无法修改;二来，每次get_val()就需要计算一次，更大的资源被耗费了。
    //综合解决办法，给val用mutable修饰，允许在get_val()里面修改，同时我再定义一个mutable修饰的is_cal变量，用来记录val是否被计算。
    //在每次get_val()我都先访问is_cal,所以，综合下来问题完美解决
```

``` cpp
//Lambda表达式
[capture](parameters){body};
auto add = [=]{++global_x;}
[x,&y]
[this]  //this指针也是需要手动传入的

auto func = [x]() mutable{
    x++;   //按值捕获x，但仍然可以改变x，不影响外部
}
```

``` cpp
#include <cmath>
double cos(double angle);
double log(); //返回自然对数
double pow(double,double); //返回a的b次方
double hypot(double,double);//返回平方的和的平方根
double sqrt(double);
int abs(int);
double fabs(double);  //返回小数的绝对值
double floor(double);  

#include <ctime>
srand();  //设置种子值
int i =rand();  //生成实际的随机数

#include <numbers>
std::numbers::pi;
std::numbers::e;
std::numbers::phi;    //黄金比例

```

``` cpp
setw();       //用来格式化输出,保证整齐

strcpy(s1,s2);
strcat(s1,s2);
strlen(s);
strcmp(s1,s2);
strchr(s1,ch);
strstr(s1,s2);

//String类

```
<<<<<<< HEAD

``` cpp
 //构造函数
 ClassName(params):name
 //拷贝函数
 ClassName(const ClassName &obj){
    
 }
```

> 上面的还是太简单了，准备放大招了
## Huge BOSS
##### 智能指针
> std::unique_ptr  资源不共享
> std::shared_ptr  资源可以共享，要防止循环引用

如何防止？自己慢慢再去查文档吧，

##### for_each
``` cpp
using namespace std;
    void MyPrint(int val) {
        cout<<val<<endl;
    }

    class Sum {
    public:
        int total = 0;
        void operator()(int num) {
            total+=num;
            cout<<num<<endl;
        }
    };

    int test() {
        std::cout << "hello world"<<std::endl;
        vector<int> v;
        v.push_back(10);
        v.push_back(20);
        v.push_back(30);
        v.push_back(40);

        vector<int>::iterator pBegin = v.begin();
        vector<int>::iterator pEnd = v.end();
        cout<<"method 1"<<endl;
        while (pBegin!=pEnd) {
            cout<<*pBegin<<endl;
            pBegin++;
        }
        cout<<"method 2"<<endl;
        for (vector<int>::iterator it=v.begin();it != v.end();it++) {
            cout<<*it<<endl;
        }
        cout<<"method 3"<<endl;
        for_each(v.begin(),v.end(),MyPrint);
        //高级写法
        //lambda表达式
        for_each(v.begin(),v.end(),[](int num){cout<<num<<endl;});
        //使用函数对象
        Sum sum = for_each(v.begin(),v.end(),Sum());
        return 0;
    }
```
##### 函数对象 & lambda
> 这个可能需要以后慢慢补
=======
>>>>>>> 092873335d7b215b06f97ccc734da74bac20c77d
