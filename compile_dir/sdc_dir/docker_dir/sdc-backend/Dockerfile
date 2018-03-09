#继承image1的基础镜像
FROM sdc-backend_base
RUN cd ${JETTY_BASE}/webapps/ && rm *.war
ADD *.war ${JETTY_BASE}/webapps/
