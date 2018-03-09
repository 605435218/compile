#/bin/bash
#获取源码
project_name="这里填jenkins上的工程名"
#删除上一次获取的工程
if [ ! -d /$project_name ]
  then
      rm -rf $project_name
fi

#拷贝工作空间
docker cp jenkis:/var/jenkins_home/workspace/$project_name ./
if [ "$?" = "0" ] 
then
   echo "工作空间拷贝成功"
else
   echo "工作空间拷贝失败"
   exit 1
fi

path=$(pwd)
#java工程需要编译,python工程可注释这一段
#根据实际情况进入到工程pom文件所在目录
cd $project_name/....
mvn install
if [ "$?" = "0" ] 
then
   echo "编译通过"
else
   echo "编译失败"
   exit 1
fi

#返回build_docker.sh所在目录
cd $path/docker_dir
#打包推送镜像
./build_docker.sh
if [ "$?" = "0" ] 
then
   echo "打包成功"
   cd $path
   rm -rf $project_name
else
   echo "打包失败"
   cd $path
   rm -rf $project_name
   exit 1
fi
