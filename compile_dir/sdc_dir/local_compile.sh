#!/bin/bash
git clone http://10.190.49.99:8080/NFVO.git
if [ "$?" = "0" ] 
then
   echo "下载代码成功"
else
   echo "下载代码失败"
   exit 1
fi
mv NFVO/src/sdc ./
if [ "$?" = "0" ] 
then
   echo "移动sdc目录成功"
else
   echo "移动sdc目录失败"
   exit 1
fi
rm -rf NFVO
cd sdc
mvn install  -Dmaven.test.skip=true -o
if [ "$?" = "0" ] 
then
   echo "编译通过"
else
   echo "编译失败"
   cd ..
   rm -rf sdc
   exit 1
fi
cd ..
cd docker_dir
./build_docker.sh
if [ "$?" = "0" ] 
then
   echo "打包成功"
   cd ..
   rm -rf sdc
else
   echo "打包失败"
   cd ..
   rm -rf sdc
   exit 1
fi
