#!/bin/bash
path=$(pwd)
time=$(date +%Y-%m-%d_%H_%M_%S)
project_name="mso"

#进入mso镜像目录
cd $path/mso_image

#确保目录下只有Dockerfile
if [ $(ls|wc -l) -gt 1 ]
  then
  rm -rf $(ls|grep -v Dockerfile)
fi

#拷贝mso镜像到需要的文件到image1目录
cp ../../so/mso-api-handlers/mso-api-handler-infra/target/mso-api-handler-infra-1.1.1-SNAPSHOT.war  ./
cp ../../so/adapters/mso-vfc-adapter/target/mso-vfc-adapter-1.1.1-SNAPSHOT.war  ./
cp ../../so/adapters/mso-workflow-message-adapter/target/mso-workflow-message-adapter-1.1.1-SNAPSHOT.war  ./
cp ../../so/adapters/mso-catalog-db-adapter/target/mso-catalog-db-adapter-1.1.1-SNAPSHOT.war  ./
cp ../../so/adapters/mso-vnf-adapter/target/mso-vnf-adapter-1.1.1-SNAPSHOT.war  ./
cp ../../so/adapters/mso-sdnc-adapter/target/mso-sdnc-adapter-1.1.1-SNAPSHOT.war  ./
cp ../../so/adapters/mso-tenant-adapter/target/mso-tenant-adapter-1.1.1-SNAPSHOT.war ./
cp ../../so/adapters/mso-network-adapter/target/mso-network-adapter-1.1.1-SNAPSHOT.war ./
cp ../../so/adapters/mso-requests-db-adapter/target/mso-requests-db-adapter-1.1.1-SNAPSHOT.war ./
cp ../../so/asdc-controller/target/asdc-controller-1.1.1-SNAPSHOT.war ./
cp ../../so/bpmn/MSOCockpit/target/MSOCockpit-1.1.1-SNAPSHOT.war ./
cp ../../so/bpmn/MSOInfrastructureBPMN/target/MSOInfrastructureBPMN-1.1.1-SNAPSHOT.war ./

#打包mso镜像
image_name=10.190.49.56:10001/"debug_"$project_name/$time/mso_debug
docker build -t $image_name  .

#打包完成后清空镜像文件夹下的war包
if [ $(ls|wc -l) -gt 1 ]
  then
  rm -rf $(ls|grep -v Dockerfile)
fi

#登录私服，推送镜像
docker login -u docker -p docker 10.190.49.56:10001
docker push $image_name

#推送完成后删除本机镜像
docker rmi $image_name
