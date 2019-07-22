# 自定义编码规范

这个是为了快速的更好的根据第三方接口, 一套服务, 这样可以快速的完成开发任务

首先, 基础标准是阿里巴巴java 规范那一套,这里说的都是在这个上面加的

## 杂乱

* 先确定最终效果

* 配置文件对应的实体类放置在统一的地方

* 写接口的时候,如果有对应的sdk, 在设计前端变量, dto, vo,entity的时候, 注意字段名和类型, 要和sdk 的一致 `或则写一个属性映射注解 @ApiField("biz_type")`



## 命名

### 关于变量的命名

接收到前台传过来的数据dto中的字段名,数据类型,和Entity表数据类型,变量名一致

这可以方便我们当字段比较多的时候,可以拷贝数据,

### POJO 命名

数据传输用DTO, 输出传到前台显示用 VO, 和表实现映射的用 Entity


### 关于异常抛出

使用spring 中的Assert, 这个可以减少if判断

```java
import org.springframework.util.Assert;
```

### 日志

### 插件

* lombok 

作用： 
     1.可以不用写get/set方法,有参无参构造方法等
     2.日志打印加`@Slf4j`直接调用 `log.info()`
     注意：idea 需要安装插件, 且需要导入这个包

```xml
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <optional>true</optional>
    </dependency>
```

日志范例:

```java
@Slf4j
@Service
public class MenuServiceImpl implements MenuService {

    @Override
    public List<MenusEntity> listMenus(String role) {
        log.info("get menu , role : {}",{});
       // .. 以下省略返回值
    }
}
```

### 工具类

* String 类型处理
`org.springframework.util.StringUtils` 这个工具类了解一下, 还是一个`abstract class` 可以自己写一个类扩展继承一下

注意： `org.springframework.util` 这个包下还有一些其他的工具类, 可以找下

* bean 复制

`org.springframework.beans.BeanUtils` 可以实现bean 的复制

### 数据库设计

* mysql 只存储一些关键的数据, 减少数据库中的数据, 其他的一些数据,可以在需要使用的时候,在通过接口去第三方数据中获取

### 测试

* 方法粒度小, 方便测试,也方便后台在线上,通过url 来进行测试

### 逻辑

#### 消除if else

* 看下是否可以用map 来代替if判断

* 是否可以用 Assert 来代替判读

* 看下是否可以通过工厂方法消除

#### 对象

* 如果一个对象创建比较频繁, 是否可以用map 来进行存储


### 技术栈

#### 工具类

```xml
        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
            <version>28.0-jre</version>
        </dependency>
```


