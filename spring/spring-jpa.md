# spring jpa

### 问题

Q1: Not a managed type
```java

@EntityScan(basePackages = "io.siberia.sercurity.bean.entity")
@EnableJpaRepositories(
        basePackages = "io.siberia.sercurity.repository",
        repositoryFactoryBeanClass = DataTablesRepositoryFactoryBean.class);

```

Q2: Executing an update/delete query

因为jpa要求，‘没有事务支持，不能执行更新和删除操作’。

就是在Service层或者Repository层上必须加@Transactional

