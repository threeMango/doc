# 问题笔记

### 多模块搭建问题

Q1 : backend 引入 core 后, 无法用注解@Autowired在UserControler自动导入UserService说无法找到bean?

原因: 没有扫描到

解决方案: 在BackendApplicatoin上添加包扫描路径

### 配置不起作用

Q1 : JwtFilter 放在 core模块下的 io.siberia 模板下, 不起作用,已经标注了@WebFilter

原因: 很简单嘛, @WebFilter 这个注解没有被扫描到, 所以没有效果喽( 用 @ServletComponentScan 来扫描)

解决方案: 把@ServletComponentScan 放在 BackendApplication 上,然后把 JwtFilter 这个类放在backend 项目模块下