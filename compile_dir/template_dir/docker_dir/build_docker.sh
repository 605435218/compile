#!/bin/bash
#请根据实际情况修改镜像变量名称和填入工程名称
#以下为了演示镜像名称使用image1 2 3 4....
path=$(pwd)
time=$(date +%Y-%m-%d_%H_%M_%S)
project_name="填入工程名"
#拷贝image1需要的文件到image1目录
cd $path/image1
#清理掉除了Dockerfile之外的所有文件
if [ $(ls|wc -l) -gt 1 ]
  then
  rm -rf $(ls|grep -v Dockerfile)
fi

#拷包操作
#cp ....
#打包image1,新镜像可按需要命名，默认按日期命名
image1_name=10.190.49.56:10001/"debug_"$project_name/$time/image1_debug
docker build -t $image1_name  .
#打包完成后清理掉除了Dockerfile之外的所有文件
rm !(Dockerfile)

#拷贝image2需要的文件到image2目录
cd $path/image2
#清理掉除了Dockerfile之外的所有文件
rm !(Dockerfile)
#拷包操作
#cp ....
#打包image2,新镜像可按需要命名，默认按日期命名
image1_name=10.190.49.56:10001/"debug_"$project_name/$time/image2_debug
docker build -t $image2_name  .
#打包完成后清理掉除了Dockerfile之外的所有文件
if [ $(ls|wc -l) -gt 1 ]
  then
  rm -rf $(ls|grep -v Dockerfile)
fi

#...

#根据实际需要加上一些自定义操作


#推送镜像到私服
#推送前确保/etc/docker/daemon.json中加入了私服地址
#获取root权限后使用命令：vim /etc/docker/daemon.json 编辑/etc/docker/daemon.json文件
#编辑后文件内容如下
#{
#  "registry-mirrors": ["https://registry.docker-cn.com"],
#  "insecure-registries":["nexus3.onap.org:10001","nexus3.onap.org","10.190.49.56:10001"]
#}
#使用命令:service docker restart重启docker服务

#登录私服，推送镜像
docker login -u docker -p docker 10.190.49.56:10001
docker push image1_name
docker push image2_name

#删除本地镜像
docker rmi image1_name
docker rmi image2_name
