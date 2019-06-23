# 项目

## 项目结构

common: 功能模块
component: 组件模块
    - security: 安全认证模块

## 开发工具

IntelliJ IDEA : 
    * plugin 
        - lombok

## 项目架构
* 所有异常向上抛出，提交到客户  (案例类： GlobalDefaultExceptionHandler) 

* 登录用户认证采用 jwt - 把登录信心加密后放在用户的请求头中
