# 自定义编码规范

首先, 基础标准是阿里巴巴java 规范那一套,这里说的都是在这个上面加的

## 命名

### 关于变量的命名

接收到前台传过来的数据dto中的字段名,和Entity表数据类型,变量名一致

这可以方便我们当字段比较多的时候,可以拷贝数据,

### POJO 命名

数据传输用DTO, 输出传到前台显示用 VO, 和表实现映射的用 Entity

## 常用的一些注解

### 关于异常抛出

使用spring 中的Assert, 这个可以减少if判断

```java
import org.springframework.util.Assert;
```

### 日志

### 关于实体类

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

### 关于Entity

* 主键自增

```java
@GeneratedValue(strategy = GenerationType.IDENTITY)
```

* 创建/更新时间

```java
// 表的类型 datetime 长度为0 小数点为 0
@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
@CreationTimestamp

```

* 只有两种状态值

```java
// 表结构 tinyint 长度为 2  -> Boolean
 @Type(type = "org.hibernate.type.NumericBooleanType")
```

### 参数验证

如果需要自定义验证规则: 看附录

一般的从前台传过来的数据会用这个数据类型进行接收,这个时候需要对某些数据进行校验
注意: 
1. 需要在 controller 接受实体的那个地方用`@Valid` ，否则不会验证
2. 验证嵌套, 在需要验证的字段之上在加上`@Valid`

```java
// 是否为空 javax.validation.constraints 这个包下有一些基本的,可以看下
@NotEmpty

```

### 工具类

* String 类型处理
`org.springframework.util.StringUtils` 这个工具类了解一下, 还是一个`abstract class` 可以自己写一个类扩展继承一下

注意： `org.springframework.util` 这个包下还有一些其他的工具类, 可以找下

* bean 复制

`org.springframework.beans.BeanUtils` 可以实现bean 的复制


## 附录

### 自定义验证器

```java

import org.springframework.core.annotation.AliasFor;

import javax.validation.Constraint;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Field;


/**
 * 使用场景: 前台穿过来一个对象, 他的某些字段只能同时为null, 或则同时不为null
 *
 * 案例:
 *      @Data
 *      @NotAloneNull(fields = {"name","age"},message = "name , age 必须同时为空 或则 非空")
 *      public class UserDto {
 *
 *          private String name;
 *
 *          private String age;
 *      }
 */

@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = NotAloneNull.NotAloneNullValidator.class )
public @interface NotAloneNull {

    @AliasFor(value = "value")
    String[] fields() default {};

    String message() default "not alone null";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    class NotAloneNullValidator implements ConstraintValidator<NotAloneNull,Object> {

        private String[] fields;

        @Override
        public void initialize(NotAloneNull constraintAnnotation) {
            this.fields = constraintAnnotation.fields();
        }

        @Override
        public boolean isValid(Object value, ConstraintValidatorContext context) {
            boolean isValid = false;
            int count = 0;

            Class<?> aClass = value.getClass();
            try {
                for (String fieldName : this.fields) {
                    Field declaredField = aClass.getDeclaredField(fieldName);
                    declaredField.setAccessible(true);
                    Object o = declaredField.get(value);

                    count = (null == o) ? ++count : count;
                }

                isValid = (count == (this.fields.length) || (count == 0));

            }catch (Exception e) {
                e.printStackTrace();
            }

            return isValid;
        }
    }
}
```

```java

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 使用场景: 当一个对象里面需要多重添加判断的时候
 *
 * 使用案例:
 * @Data
 * @NotAloneNulls({
 *     @NotAloneNull(fields = {"name","age"},message = "name , age 必须同时为空 或则 非空"),
 *     @NotAloneNull(fields = {"name", "phone"}, message = "name , phone 必须同时为空 或则 非空")
 * })
 * public class UserDto {
 *
 *     private String name;
 *
 *     private String age;
 *
 *     private String phone;
 * }
 *
 */
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface ManyNotAloneNull {

    NotAloneNull[] value();

}
```










