---
layout:     post
title:      "Hello Golang"
subtitle:   " \"let's us learn Golang\""
date:       2025-11-02 12:00:00
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Golang
---
 ``` Golang
package main
import (
    "fmt"
)

func main(){
    fmt.Println("Hello World")

}
 ```
##### Go的规定
* 对于导出的变量或其他，必须以大写字母开头,如:math.Pi 合法，math.pi不合法
* Go中使用是：类型在变量名后面
* 函数可以有多个返回值
> func swap(x,y string) (string,string){
    return y,x
}
* 可以通过命名进行返回值返回
>func split(sum int) (x,y int){
    x = sum *  3
    y = sum - 2
    return
}
* 变量
> var一般出现在包级别，函数级别
go有类型推断， var i,j = 1,2.0
短赋值语句隐式确定类型 a := 1
go允许不初始化，不初始化的会被赋予0值
go中不允许隐式转换，强制显示转换 i:= float64(32)
常量使用const关键字
* for(go中没有while)
>for i:=0;i<10;i++{
    to do sth just you like
}
在go中，常用for{}表示无限循环
* if很类似，也是无需小括号
* switch
>go的switch中可以有default:
go中默认break,如果想要贯穿，需要fallthrough(这点和其他编程语言十分不同)
go 中case的取值也十分随意
* defer推迟函数
>go中特别好用的一个东西，会在return之后执行defer的代码
* 指针
>go中提供指针 var p *int
i := 1
p = &i
*p 底层值
* struct
>type Example struct{
    X int
    Y int
}
在go中尽管我们定义一个指针，但是在使用时不需要p->X，直接p.X就行
go中属于隐式解引用
并且fmt.Print(p)也不会打印地址，而是打印出p的解引用的值
* 数组 num [n]T
* 切片 num []T 这个会py的可以笑了，这切片太好用了numpy狂喜
>num[1:4] 左开右闭
bool_arr := [3]bool{true,true,true}
struct_arr :=
切片的零值是nil
用make创建切片 a := make([]int ,5) //len(a)=5
b := make([]int ,0,5) //len(b)=0 cap(b)=5
append(b,2)
* range遍历
>for i,v :=range 切片数组{
    //添加操作
}
* map
m := map[string]int{
    "a": 1
}
elem = m["a"]
delete(a,1)
elem,ok := m["a"]
* 函数也是值
>经典lambda: result := func(x,y int) int{
        return x*y
}
经典闭包： func adder() func(int) int {
    sum := 0
    return func(x int)int{
        sum += x
        return sum
    }
}
* 震惊，go中没有类
>不过你可以为类型定义方法
func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}
调用:  v.Scale(f)
func (v Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}
注意上面两个函数完全不同，一个是副本传递，一个是引用传递
* 方法与指针重定向
>//这里有一个比较逆天的东西,需要好好解决一下

* 接口
>type Abser interface{
    Abs() float64
}
* 隐式接口
>type I interface {
	M()
}
func (t T) M() {
	fmt.Println(t.S)
}

* 接口值


* 底层为nil的接口值
>func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}

* 空接口

* 类型断定
>t,ok := i.(T)
* 类型选择
>switch v:=i.(type){
    case T:
    case S:
}
* Stringer

* error

