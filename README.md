# 简介

记录一些笔记,方便查询

```bash
把gitbook 项目提交到gitHub，可以自定触发git 页面更新

步骤：

假设已经有docker环境,且已经安装好了docker-compose

1. 修改 `docker-compose` 下的 BOOK_URL 环境变量

2. 上传到服务器, 提交到直接运行 `docker-compose up -d`

3. 在github上配置 webhooks (每次同步到远程仓库,都会发送一个请求到 指定url去, 然后在那里执行 拉取操作)

```


