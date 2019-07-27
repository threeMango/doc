# 基本注解

### 关于Entity

* 主键自增

```java
@GeneratedValue(strategy = GenerationType.IDENTITY)
```

* 创建/更新时间

表的类型 datetime 长度为0 小数点为 0

```java
@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
@CreationTimestamp
```

* 只有两种状态值

 表结构 tinyint 长度为 2  -> Boolean

```java
 @Type(type = "org.hibernate.type.NumericBooleanType")
```
