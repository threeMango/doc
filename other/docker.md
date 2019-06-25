# docker

## 基本操作

### 环境搭建

### 镜像操作

* 查看所有镜像

```bash
docker images
```

* 删除镜像(如果有容器是靠这个镜像来的,需要先停止)

```bash
# 删除单个镜像
docker rmi <image id>

# 删除所有镜像
docker rmi $(docker images -q)

# 强制删除所有镜像
docker rmi -f $(docker images -q)
```

### 容器操作

* 查看所有状态下的容器

```bash
docker ps -a 
```

* 单个容器操作

```bash
# 停止一个容器
docker stop Name或者ID 

# 启动一个容器
docker start Name或者ID 

# 杀死一个容器
docker kill Name或者ID  

# 重启一个容器
docker restart name或者ID

# 进入一个容器
docker exec -it 容器id /bin/bash
```

* 停止所有容器

```bash
docker stop $(docker ps -a -q)

docker stop $(docker ps -aq)
```

* 删除容器

```bash
# 删除所有容器
docker rm $(docker ps -a -q)

docker rm $(docker ps -aq)
```

* 文件复制操作

```bash 
# 宿主机 -> 容器
docker cp 宿主路径中文件      容器名:  容器路径   

# 容器 -> 宿主机
docker  cp 容器名:  容器路径       宿主机路径
```

