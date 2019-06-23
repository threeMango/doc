FROM node:9.3.0

MAINTAINER 79149974@qq.com

WORKDIR ./gitbook

RUN npm --registry https://registry.npm.taobao.org install gitbook-cli -g

RUN gitbook init

EXPOSE 4000