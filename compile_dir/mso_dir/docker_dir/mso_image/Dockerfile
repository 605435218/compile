#继承image1的基础镜像
FROM mso_base
RUN cd /opt/jboss/standalone/deployments&&rm -rf *
#把image1需要的文件添加到基础镜像的对应路径下
ADD   *.war   /opt/jboss/standalone/deployments/
