# Arthas

## 命令

[arthas 命令](https://alibaba.github.io/arthas/watch.html#) 

## 场景 1 docker-compose + spring boot 

docker-compse对容器做编排,spring boot 运行的backend.jar文件 

在宿主机(server/backend.jar) -> 容器(data/backend.jar)


1, 进入 docker

```bash
docker exec -it gateway /bin/bash
```

2, 下载 安装 arthas

```bash
# 下载
wget https://alibaba.github.io/arthas/arthas-boot.jar

# 安装 选择启动的 jar 程序  选择你要操作的jar
java -jar arthas-boot.jar 

```

3, 热加载class文件

现在线下做修改,然后在上传文件, 然后在执行
```bash
redefine /tmp/Test.class
```

注意：redefine的限制 https://alibaba.github.io/arthas/redefine.html


