#/bin/bash
#获取源码
project_name="这里填jenkins上的工程名"
#删除上一次获取的工程
if [ ! -d $project_name ]
  then
      rm -rf $project_name
  fi
docker cp jenkis:/var/jenkins_home/workspace/$project_name ./

#java工程需要编译,python工程可注释这一段
cd $project_name
mvn clean install
cd ..

#打包推送镜像
cd docker_dir
./build_docker.sh
