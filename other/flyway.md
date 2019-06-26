# flyway

### flyway 工作过程

官方说明: <a href = "https://flywaydb.org/getstarted/how" >点击这里</a>

情况一： 数据库为空

1. 先去找`flyway_schema_history`这个表(用来记录那些已经更新),如果没有就创建一个

2. 然后扫描文件, 安装版本号从小到大开始执行sql 文件, 执行一个文件, 插入更新一条数据

3. 不在执行已经在`flyway_schema_history`有对应版本号的文件


情况二： 数据库不为空 & `flyway_schema_history`也没有(没找到官方说明)

这段输出是spring boot 启动的时候( 配置属性: baseline-version: 20190606001)

```java
Successfully validated 2 migrations (execution time 00:00.260s)
Creating Schema History table: `antpay_v1`.`flyway_schema_history`
Successfully baselined schema with version: 20190606001
Current version of schema `antpay_v1`: 20190606001
Migrating schema `antpay_v1` to version 20190606002 - v1 to v2
```
1. 校验sql文件是否对 依靠 flyway_history 中的checksum这个字段来校验, 如果有改变,则会发生异常
2. 创建`flyway_schema_history`表
3. 设置当前版本为 20190606001 (是不是意味着不会执行小于等于这个版本号的sql 文件)
4. 执行版本号高的sql文件

情况三: 数据库不为空 & `flyway_schema_history`已经创建 (没找到官方说明)
1. 根据 `flyway_schema_history` 这个表找到当前版本
2. 执行比这个更高的版本的sql文件


### 注意点

* 版本文件命名规则：`V版本号__描述.sql`(例如: `V20190605001__init.sql`   **后面有两个下划线(可以修改见附录属性配置)**)
    
    否则可能会抛出这个异常： `org.flywaydb.core.api.FlywayException: Wrong migration name format`

* sql 文件中 字段名用 ` `` `  数值用 ` '' `

### 使用
* 如果原来已经有数据库,先备份, 如果没有则新建一个数据库 
* 配置文件中：spring.flyway.enable = true
* 必须先存在数据库, 所以需要新建数据库. 例如：`antpay`

### 构建版本化语句(navicat)

写在前面：结构/数据同步需要用到 navicat => 工具 | 结构同步 | 下一步 | 部署 => 复制执行脚本 

1. 首先： 你需要有一个第一个版本的数据库, 记做 antpay_v1 (表中除了一些必须的数据以外, 其他数据都没有)
    * 这个简单, 拿到那个数据库的sql文件, 运行一下sql文件就出来

2. 然后:  你需要有一个最新数据的数据库, 记做 antpay_v2
    * 先新建一个数据 `antpay_v2` 
    * 接着, 用 `结构同步` 用 现在最新的数据库 去对比新建的数据库 `antpay_v2`,把表结构同步过来, 然后直接运行部署就好
    * 最后，用 `数据同步` 用 现在最新的数据库 去对比已经有表结构的数据 `antpay_v2`, 把不需要的同步数据的表直接取消就好,  然后直接运行部署就好
    * 注意： 把这个版本的数据库，生成一个sql文件, 方便以后对比

3. 接着： 用 `结构同步` 生成两个数据库中的表结构对比语句 (新增加了那些表啊，新加了哪些字段啊)
    * 先用 `结构同步` 工具生成结构差异sql (用 antpay_v2 去对比 antpay_v1)
    * 然后把差异化语句, 复制到一个新建的文件中(文件名: V20190605001_xx_yy.sql)

4. 最后： 用 `数据同步` 把一些系统初始化数据据, 加到表中
    * 先执行 `antpay_v2` 对比 `antpay_v1` ， 结构同步 ,也就是说这个时候的 `antpay_v1` 表结构和 `antpay_v2` 一样了 
    * 然后执行 数据同步 把差异化语句放到 sql 文件中 (比如上一步的: V20190605001_xx_yy.sql)

5. 最后的最后： 把sql 文件中的所有 `antpay_v1`, 替换为 `antpay` 

注意点： 
* mysql 语句中的可能会导致用户数据被删除或修改的关键字 `truncate` ,  `delete` , `drop` , `ALTER` ,`update`

### 附录

#### flyway 扩展

* <a href="https://flywaydb.org/documentation/callbacks">hook into migrations lifecycle</a>

#### spring boot flyway 配置

```yaml
spring:
    flyway:
        enabled: true
        cleanDisabled: true
        locations: classpath:db/migration
        baseline-on-migrate: true
        baseline-version: 20190606001
```        

```properties
flyway.baseline-description对执行迁移时基准版本的描述.
flyway.baseline-on-migrate当迁移时发现目标schema非空，而且带有没有元数据的表时，是否自动执行基准迁移，默认false.
flyway.baseline-version开始执行基准迁移时对现有的schema的版本打标签，默认值为1.
flyway.check-location检查迁移脚本的位置是否存在，默认false.
flyway.clean-on-validation-error当发现校验错误时是否自动调用clean，默认false.
flyway.enabled是否开启flywary，默认true.
flyway.encoding设置迁移时的编码，默认UTF-8.
flyway.ignore-failed-future-migration当读取元数据表时是否忽略错误的迁移，默认false.
flyway.init-sqls当初始化好连接时要执行的SQL.
flyway.locations迁移脚本的位置，默认db/migration.
flyway.out-of-order是否允许无序的迁移，默认false.
flyway.password目标数据库的密码.
flyway.placeholder-prefix设置每个placeholder的前缀，默认${.
flyway.placeholder-replacementplaceholders是否要被替换，默认true.
flyway.placeholder-suffix设置每个placeholder的后缀，默认}.
flyway.placeholders.[placeholder name]设置placeholder的value
flyway.schemas设定需要flywary迁移的schema，大小写敏感，默认为连接默认的schema.
flyway.sql-migration-prefix迁移文件的前缀，默认为V.
flyway.sql-migration-separator迁移脚本的文件名分隔符，默认__
flyway.sql-migration-suffix迁移脚本的后缀，默认为.sql
flyway.tableflyway使用的元数据表名，默认为schema_version
flyway.target迁移时使用的目标版本，默认为latest version
flyway.url迁移时使用的JDBC URL，如果没有指定的话，将使用配置的主数据源
flyway.user迁移数据库的用户名
flyway.validate-on-migrate迁移时是否校验，默认为true.

```
