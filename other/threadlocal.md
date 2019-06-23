# ThradLocal

### 关于ThreadLocal

线程单例模式, 也就是说, 在一个线程中(一个访问请求中), 里面的值是可以被改线程中的执行方法所共享的

### 使用

```java

/**
 * 用户jwt 携带的信息
 *  ThreadLocal 线程单例模式
 */
@Data
public class UserInfoDto {

    private static final ThreadLocal<UserInfoDto> info = new ThreadLocal<UserInfoDto>() {
        @Override
        protected UserInfoDto initialValue() {
            return new UserInfoDto();
        }
    };

    private String name;

    private UserInfoDto() {}

    public static UserInfoDto getInstance() {
        return info.get();
    }

}

```

