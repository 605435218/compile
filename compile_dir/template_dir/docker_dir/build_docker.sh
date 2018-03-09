#!/bin/bash
#请根据实际情况修改镜像名称和填入工程名称
#以下为了演示镜像名称使用image1 2 3 4....
path=$(pwd)
time=$(date +%Y-%m-%d_%H_%M_%S)
#这里填工程名
project_name=""
#这里填入所有镜像的名字
image_name_list=(
"image1"
"image2"
)
#这里填入所有镜像的启动命令,因为数组元素中填入空格会出现奇怪的后果，启动命令中的空格用两个_代替，如:docker__run__-d__-p__8080:8080:
image_cmd_list=(
“docker__run__-d__-p__8080:8080”
"cmd2"
)
#这里填入拷包操作的源路径和目的路径，中间用;隔开,不要有空格(当前位置为脚本所在目录)
copy_file_list=(
"src_dir1;dest_dir1"
"src_dir2;dest_dir2"
)

#清理镜像目录
for i in ${image_name_list[*]}
do
cd $path/$i
#清理掉除了Dockerfile之外的所有文件
if [ $(ls|wc -l) -gt 1 ]
  then
  rm -rf $(ls|grep -v Dockerfile)
fi
done

cd $path

#拷包
for i in ${copy_file_list[*]}
do
#分号换成空格做参数传入
cp $(echo $i|sed 's/;/ /g')
done

#登录私服
docker login -u docker -p docker 10.190.49.56:10001
if [ "$?" = "0" ]
then
   echo "登录私服成功"
else
   echo "登录私服失败"
   exit 1
fi


#邮件脚本的参数
mail_args=$project_name
#打包推送
num=0
for i in ${image_name_list[*]}
do
#进入镜像目录
cd $path/$i
#构造镜像名
image_name=10.190.49.56:10001/"debug_"$project_name/$time/$i"_debug"
#打包镜像
docker build -t $image_name  .
if [ "$?" = "0" ]
then
   echo $image_name" 打包成功"
else
   echo $image_name" 打包失败"
   exit 1
fi
#推送镜像
docker push $image_name
if [ "$?" = "0" ]
then
   echo $image_name" 推送成功"
else
   echo $image_name" 推送失败"
   exit 1
fi
#打包完成后清理掉除了Dockerfile之外的所有文件
if [ $(ls|wc -l) -gt 1 ]
  then
  rm -rf $(ls|grep -v Dockerfile)
fi
#删除本机镜像
docker rmi $image_name
if [ "$?" = "0" ]
then
   echo "本地镜像: "$image_name" 删除成功"
else
   echo "本地镜像: "$image_name" 删除失败"
   exit 1
fi
#镜像名和启动命令用;拼接作为邮件脚本参数
mail_args+=" "$image_name";"${image_cmd_list[$num]}
num=`expr $num + 1`
done

#将打包结果通过邮件发出，把工程名所有镜像名字作为参数输入
cd $path
./mail.py $mail_args
if [ "$?" = "0" ]
then
   echo "打包流程完成"
else
   echo "打包流程失败"
   exit 1
fi
