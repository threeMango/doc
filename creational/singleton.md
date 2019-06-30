# 单例模式

**定义:** 保证一个类仅有一个实例, 并提供一个全局访问点

**类型:** 创建型

**场景:** 却把在任何情况下都绝对只有一个实例，比如 多服务情况下的计数器, 应用配置, 线程池, 数据库连接池

**优点：**

在内存里只有一个实例, 减少内存开销

避免资源的多重占用, 比如文件的写操作

全局访问点, 严格的控制访问. 只能通过一个类的方法来获取, 无法new 出来

**缺点:**

没有接口, 扩展困难

**重点:**

私有构造

线程安全

延迟加载

序列化和反序列安全

反射攻击

**相关设计模式：**

单例模式和工厂模式

单例模式和享元模式


## 演进-懒汉式(延迟加载)

### 普通 - 线程不安全

线程不安全: 在多线程情况可能会生成两个对象

```java
public class LazySingleton {
    private static LazySingleton instance = null;

    private LazySingleton() {}

    public static LazySingleton getInstance() {
        if (null == instance) {
            instance = new LazySingleton();
        }

        return instance;
    }

}
```

### 验证普通方法多线程不安全

这里有用多线程debug, (直接run 是看不见的)

```java
/**
 * 在线程中获取对象,且打印实例
 */
public class T implements Runnable {
    public void run() {
        LazySingleton instance = LazySingleton.getInstance();
        System.out.println(instance);
    }
}
```

测试方法

```java
 public static void main(String[] args) {
        Thread thread1 = new Thread(new T());
        Thread thread2 = new Thread(new T());
        thread1.start();
        thread2.start();
}
```

### 解决线程不安全问题 synchronized

静态方法锁的是类本身, 对象锁的是在堆内存中的对象

```java
public class LazySingleton {
    private static LazySingleton instance = null;

    private LazySingleton() {}

    public synchronized static LazySingleton getInstance() {
        if (null == instance) {
            instance = new LazySingleton();
        }

        return instance;
    }

}
```
还可以这样写

```java
public class LazySingleton {
    private static LazySingleton instance = null;

    private LazySingleton() {}

    public synchronized static LazySingleton getInstance() {
        synchronized (LazySingleton.class) {
            if (null == instance) {
                instance = new LazySingleton();
            }
        }
        
        return instance;
    }

}
```

### DoubleCheck 双重检查

synchronized 锁的是类对象, 影响比较大,而且这样有一个每次访问都会导致加锁减锁的一个开销

改进方案: 减少锁住的次数，只在第一次创建这个对象的时候会锁

```java
public class LazySingleton {
    private static LazySingleton instance = null;

    private LazySingleton() {}

    public synchronized static LazySingleton getInstance() {
        if (null == instance) {
            synchronized (LazySingleton.class) {
                if (null == instance) {
                    instance = new LazySingleton();
                }
            }
        }

        return instance;
    }

}
```

### 指令重排序

产生原因: `instance = new LazySingleton();` 这行代码
 
有三个步骤: 第一步: 开辟一块内存空间  第二步: 初始化  第三步: 把内存地址赋给 `instance`

jvm 虚拟机规范允许在单线程不会改变执行结构的一些操作,(指令重排序可以提高性能) 允许第二步, 第三步对调，也就是先赋地址值给`instance`, 然后在内存地址赋予初始值

这个在单线程中没有问题, 但是在多线程中呢？

假设: 线程 A , 线程B

线程A执行完成: 第一步: 开辟一块内存空间  第二步: 把内存地址赋给 `instance`

这个时候线程B 进来 判断 `null == instance` 这个是时候当然不为空,然后就直接返回`instance`, 拿着还没有 初始化完成 的对象去操作，这样就可能出现问题


#### 不允许指令重排序

关键字：volatile

```java
public class LazySingleton {
    private volatile static LazySingleton instance = null;

    private LazySingleton() {}

    public synchronized static LazySingleton getInstance() {
        if (null == instance) {
            synchronized (LazySingleton.class) {
                if (null == instance) {
                    instance = new LazySingleton();
                }
            }
        }

        return instance;
    }

}
```

#### 允许指令重排序但不允许别的线程看见

静态内部类: Class 初始化锁

```java
public class LazySingleton {

    private LazySingleton() {}

    public static LazySingleton getInstance() {
        return Inner.instance;
    }

    private static class Inner {
        private static LazySingleton instance = new LazySingleton();
    }

}
```

### 饿汉式

方法1：final 在类加载完成时候, 就要完成赋值

```java
public class Singleton {

    private final static Singleton instance = new Singleton();

    private Singleton() {}

    public static Singleton getInstance() {
        return instance;
    }

}
```

方法2：static 块, 是类加载中的一部分, 初始化一些类对象有关的数据

```java
public class Singleton {

    private final static Singleton instance;

    static {
        instance = new Singleton();
    }

    private Singleton() {}

    public static Singleton getInstance() {
        return instance;
    }

}
```

#### 序列化反序列化破坏单例模式

第一步: 单例对象实现 `Serializable` 接口

```java
public class Singleton implements Serializable {

    private final static Integer serialVersionUID = 123;

    private final static Singleton instance;

    static {
        instance = new Singleton();
    }

    private Singleton() {}

    public static Singleton getInstance() {
        return instance;
    }

}
```

测试: 结果 `false`

```java
public class Test {

    public static void main(String[] args) throws IOException, ClassNotFoundException {
        Singleton instance = Singleton.getInstance();

        ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("singleton"));
        oos.writeObject(instance);

        File file = new File("singleton");
        ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file));

        Singleton o = (Singleton)ois.readObject();

        System.out.println(o == instance);
    }
}
```

解决：添加方法 `private Object readResolve() {return instance;}`

原因: `ObjectInputStream`类中的`readObject` 方法

```java
public class Singleton implements Serializable {

    private final static Integer serialVersionUID = 123;

    private final static Singleton instance;

    static {
        instance = new Singleton();
    }

    private Singleton() {}

    public static Singleton getInstance() {
        return instance;
    }

    private Object readResolve() {
        return instance;
    }
}
```

#### 反射攻击

#### ThreadLocal

## 应用







