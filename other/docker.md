# docker

## 基本操作

### 环境搭建

[官方文档地址](https://docs.docker.com/install/linux/docker-ce/centos/)

#### centos 7.3 + docker ce

1. 移除之前的docker 

```bash
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

```

2. 安装docker 仓库

```bash
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

3. 配置docker 仓库

```bash
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

```

4. 安装docker ce

```bash
# 安装cli
$ sudo yum install docker-ce docker-ce-cli containerd.io

# 查询所有版本
$ yum list docker-ce --showduplicates | sort -r

docker-ce.x86_64  3:18.09.1-3.el7                     docker-ce-stable
docker-ce.x86_64  3:18.09.0-3.el7                     docker-ce-stable
docker-ce.x86_64  18.06.1.ce-3.el7                    docker-ce-stable
docker-ce.x86_64  18.06.0.ce-3.el7                    docker-ce-stable

# 安装指导版本  比如:docker-ce-18.09.1
$ sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
```

5. 启动

```bash
$ sudo systemctl start docker
```


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

## 附录

### DockerFile

### docker-compose

#### docker-compose 环境安装

[官方教程](https://docs.docker.com/compose/install/)

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

$ docker-compose --version
```



