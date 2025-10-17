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
persons.emplace_back("person"+i,i+60);
persons.emplace_back("person" + std::to_string(i),i+60);
//经典错误，第一种写法实质上是指针的移动

``` 
 

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


#### STL
##### Vector
动态数组
``` cpp
#构造函数
vector<T>  v;
vector(v.begin(),v.end()); // 照旧左开右闭
vector(n,elem);  //这个我还真不常用
vector(const vector &vec);
//这里我们简单解释一下为啥经常使用cosnt T &T
//这里其实就得说引用传递的好处了，
//语法直观，避免nullptr，保持赋值时候指针类型一致，语义明确
vector& operator=(const vector &vec);
assign(v.begin(),v.end());
assign(n,elem);

empty()  //判断是否是空
capacity();
size();
resize(int num);
resize(int num ,elem);

push_back(elem);
pop_back(elem);
insert(pos,elem);
insert(pos,num,elem);
erase(start,end);
erase(pos);
clear();

at(int index);
operator[];
front();
back();

swap(vec);

reserve(int len);

```

##### deque
双端数组,底层是多个数组，通过中控数组链接
``` cpp
deque<T> dq;
deque(begin,end);
deque(n,elem);
deque(const deque &deq);

deque& operator=(const deque &deq);
assign(beg,end);
assign(n,elem);

empty();
size();
resize(num);
resize(num,elem);

push_back(elem);
push_front(elem);
pop_back();
pop_front();

insert(pos,elem);
insert(pos,n,elem);
insert(pos,beg,end);
clear();
erase(beg,end);
erase(pos);

at(index);
operator[];
front();
back();

sort(beg,end);
```

##### stack & queue & list


``` cpp
stack<T> stk;
stack(const stack &stk);
stack& operator=(const stack &stk);
push(elem);
pop();
top();
emtpy();
size();

queue<T> que;
queue(const queue &que);

push(elem);
pop();
back();
front();

empty();
size();

//链式存储，链表
list<T> lst;
list(beg,end);
list(n,elem);
list(const list &lst);

assign(beg,end);
assign(e,elem);
list& operator=(const list &lst);
swap(lst);  //list1.swap(list2)

size();
empty();
resize(num);
resize(num,elem);

push_back();
pop_back();
push_front();
pop_fornt();
insert(pos,elem);
insert(pos,n,elem);
insert(pos,beg,end);
clear();
erase(beg,end);
erase(pos);
remove(elem);  //删除所有elem

front();
end();

reverse();
sort();


```

##### set & multiset & pair
``` cpp
set<T> st;
set(const set &st);
set& operator=(const set &set);
size();
empty();
swap();
insert(elem);
clear();
erase(pos);
erase(beg,end);
erase(elem);  //通过值删除

find(key);//查找key是否存在,若存在，返回该键的元素的迭代器；若不存在，返回set.end();
count(key);


//set不可以插入重复数据，而multiset可以
//set插入数据的同时会返回插入结果，表示插入是否成功
//multiset不会检测数据，因此可以插入重复数据

//对组
pair<type,type> p (v1,v2);
pair<type,type> p = make_pair(v1,v2);

//set的排序规则
set<T,MyCompare> s2;
class MyCompare{
    public:
        bool operator()(T t1,T t2){
            //逻辑
            return ture;
            //ture则t1在前
            //对于自定义数据类型，必须指定仿函数才能插入数据
        }
}
```

##### map & multimap
``` cpp
map<T1,T2> mp;
map(const map &map);
map& operator=(const map &mp);

size();
empty();
swap(st);

insert(elem);
clear();
erase(pos);
erase(beg,end);
erase(key);

find(key);
count(key);
//仿函数排序
map<T1,T2,Mycompare> m ;


```

##### 内建函数对象
``` cpp
//内建函数对象
//std标准库提供了很多内建函数对象
```

##### 查找
``` cpp
find(beg,end,value);
find_if(beg,end,_pred);  //_pred指的是返回bool的仿函数
//find_if()可根据不同需求，灵活定义仿函数
adjacent_find();
binary_search();
cout();
cout_if();

```

##### 排序
``` cpp
sort(beg,end,_Pred);
ramdom_shuffle(beg,end);//随机调整次序
merge(beg1,end1,beg2,end2,dest); 
reverse(beg,end);

copy(beg,end,dest);
replace(beg,end,oldvalue,newvalue);
replace_if(beg,end,_Pred,newvalue);
swap(container1,container2);

```
##### 算术生成算法 & 常用集合算法
``` cpp
#include <numeric>
accumulate(beg,end,value);
fill(beg,end,value);

set_intersection // 求两个容器的交集
set_union // 求两个容器的并集
set_difference // 求两个容器的差集

set_intersection(iterator beg1, iterator end1, iterator beg2,iterator end2, iterator dest);

set_union(iterator beg1, iterator end1, iterator beg2, iterator end2,iterator dest);

set_difference(iterator beg1, iterator end1, iterator beg2,iterator end2,iterator dest);

```


