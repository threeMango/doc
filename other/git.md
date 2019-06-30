# GIT

## 基本操作

* 初始化仓库 

```bash
git init
```

*  添加到暂存区

```bash
git add .
```

* github 忽略文件

<<<<<<< HEAD
https://github.com/github/gitignore
=======
[https://github.com/github/gitignore](https://github.com/github/gitignore)
>>>>>>> 9ecff5f2dd2b7074cf56be45bca7aed792f340ab

* 提交到本地仓库

```bash
git commit -m "本次提交说明"
```

* 添加远程仓库地址

```bash
 git remote add origin remote_address
```

* 推送到远端 master 

```bash
# 第一次 加-u参数，把本地master推送到远端master,关联本地master分支和远程的master，简化推送或拉取命令
git push -u origin master

git push origin master

git push
```

* 拉取远端数据

```bash
git pull origin master
```

## 分支

* 查看本地分支

```bash
git branch
```

* 查看远程分支

```bash
git branch -a
```

* 创建分支

```bash
git branch branchName
```



