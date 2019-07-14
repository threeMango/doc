# GROOVY

这里不是为了特地的去学习groovy这门语言,学习这个我现在只是为了更好更快的用idea 的数据库插件去安装程序去生产一些文件

## 问题

因为这货也是跑java的JVM的 ,所有我只要简单的了解要给groovy 怎么使用就好

* 变量如何定义？

可以通过强类型来标记,也可以通过`def` 这个关键字来来声明

```java
    String x = "Hello";

    int x = 5;

    def _Name = "Joe"; 
```

* 方法如何定义？

```java
    // 没有参数的方法
    def methodName() { 
      //Method code 
    }

    // 携带参数
    def methodName(parameter1, parameter2, parameter3) { 
        // Method code goes here 
    }

    // 携带参数 返回值,默认值
   int sum(int a,int b = 5) {
      int c = a+b;
      return c;
   } 
```

* 方法如何传入参数？以及方法如何调用

```java
// 这里为什么要加static 估计原因和java一样
class Example {
   static void sum(int a,int b = 5) {
      int c = a+b;
      println(c);
   } 
	
   static void main(String[] args) {
      sum(6,6);
   } 
}

```

* 怎么单元测试?

* 如何导入包？怎么看里面有那些方法？

* jar是否可以直接使用java的？

## 其他

* 打印输出

```java
println "Hello from the shebang line"
```

* 字符串插值

```java
def name = 'Guillaume' // a plain string
def greeting = "Hello ${name}"
assert greeting.toString() == 'Hello Guillaume'
```



