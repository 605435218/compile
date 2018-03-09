#/bin/bash
#获取源码
project_name="这里填jenkins上的工程名"
#删除上一次获取的工程
if [ ! -d $project_name ]
  then
      rm -rf $project_name
  fi
docker cp jenkis:/var/jenkins_home/workspace/$project_name ./

path=$(pwd)
#java工程需要编译,python工程可注释这一段
#根据实际情况进入到工程pom文件所在目录
cd $project_name/....
mvn clean install

#返回build_docker.sh所在目录
cd $path/docker_dir
#打包推送镜像
./build_docker.sh
