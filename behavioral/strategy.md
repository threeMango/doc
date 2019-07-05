# 策略模式

* 场景

    *  定义了许多的算法, 分别封装起来, 让他们可以相互替换,但不会影响到算法的使用用户

    * 去除大量的 `if ... else ...`

    * 一个行为有多种实现方式, 比如: 支付 微信支付, 支付宝支付, 还有JSAPI,动态二维码,被扫等

* 优点

    * 开闭原则

    * 避免多重条件转移语句

    * 提高保密性

* 缺点

    * 客户端必须知道所有的策略类,并自行决定使用哪一个策略类

    * 产生很多策略类

* 相关设计模式
    
    * 工厂模式

    * 状态模式

## UML

基本思路: 通过接口调用子类对象, 执行方法

```UML
@startuml
interface StrategyInterface
class StrategyImpl1
class StrategyImpl2
class StrategyImpl3
class StrategyUse

StrategyInterface <|.. StrategyImpl1
StrategyInterface <|.. StrategyImpl2
StrategyInterface <|.. StrategyImpl3

StrategyInterface <-* StrategyUse

@enduml
```

## Coding

场景： 有一个功能, 支付宝和微信都支持, 一般商户只实现了一个比如支付宝, 比如微信

但是,总有意外, 同时支持了微信和支付宝, 这个时候,就需要给商户自己选择, 默认走哪个通道

这里的思路： 写一个策略接口, 分别有三种实现方式：支付宝, 微信 以及 默认

把策略由执行类中的执行方法执行

执行类有执行类工厂来实现

coding...

策略接口

```java
public interface Strategy {

    Object process();

}
```

默认优先策略

```java
public class DefaultStrategy implements Strategy {

    public Object process() {
        System.out.println("默认策略");
        return "defualt";
    }
}
```

支付有限策略

```java
public class AliPriorityStrategy implements Strategy {

    public Object process() {
        System.out.println("阿里优先策略");
        return "ali";
    }
}
```

微信优先策略

```java
public class WxPriorityStrategy implements Strategy {

    public Object process() {
        System.out.println("微信优先策略");
        return "wx";
    }
}
```

执行策略

```java
public class StrategyExecute {

    private Strategy strategy;

    public StrategyExecute(Strategy strategy) {
        this.strategy = strategy;
    }

    public Object execute() {
        return strategy.process();
    }
}
```

工厂方法
1. 减少策略实体类的创建
2. 减少应用层的代码 (这里看测试类)
3. 用map 减少了 if else 的判断

```java
public class StrategyExecuteFactory {

    private static Map<String,Strategy> STRATEGY_MAP = new HashMap<String, Strategy>();

    static {
        STRATEGY_MAP.put(StrategyName.DEFAULT,new DefaultStrategy());
        STRATEGY_MAP.put(StrategyName.ALI,new AliPriorityStrategy());
        STRATEGY_MAP.put(StrategyName.WX,new WxPriorityStrategy());
    }

    private StrategyExecuteFactory() {}

    public static StrategyExecute getStrategy(String strategyName) {
        Strategy strategy = STRATEGY_MAP.get(strategyName);

        strategy = (strategy == null) ? STRATEGY_MAP.get(StrategyName.DEFAULT) : strategy;

       return new StrategyExecute(strategy);
    }

    private interface StrategyName {
        String DEFAULT = "DEFAULT";
        String ALI = "ALI";
        String WX = "WX";
    }

}
```

测试

```java
public class Test {

    public static void main(String[] args) {
        StrategyExecute execute = StrategyExecuteFactory.getStrategy("ALI");
        Object process = execute.execute();
        System.out.println(process.toString());
    }
}
```

## 源码

* Comparator

* Resource (org.springframeword.core.io)

