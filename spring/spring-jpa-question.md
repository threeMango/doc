# 问题

* 用 `hibernate` 自动创建表,有一个编码问题.

注意下面配置
```properties
spring:
  datasource:
    url: jdbc:mysql://47.101.212.85:3306/siberia?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=true
  jpa:
    hibernate:
      dialect: org.hibernate.dialect.MySQL5InnoDBDialect
```

* spring security 自定义一个filter如何产生异常,直接到对应的 处理器中去(handle)

通过抛出特定的异常,spring security 有定义了自己的异常体系 比如: `AccessDeniedException`

`ExceptionTranslationFilter` 决定怎么样的异常到对应的处理器里面去 [官方说明](https://docs.spring.io/spring-security/site/docs/5.2.0.M3/reference/htmlsingle/#access-denied-handler)






