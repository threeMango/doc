# JAVA参数校验

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
 * 案例二：
 *   @NotAloneNull.List({
 *		@NotAloneNull(value = {"a","b"},message = "a,b 必须同时存在,或则不存在")
 *   })
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

    @Target({ElementType.TYPE})
    @Retention(RUNTIME)
    @Documented
    @interface List {
        NotAloneNull[] value();
    }


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


