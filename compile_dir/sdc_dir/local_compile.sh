#!/bin/bash
git clone http://10.190.49.99:8080/NFVO.git
mv NFVO/src/sdc ./
rm -rf NFVO
cd sdc
mvn install  -Dmaven.test.skip=true
cd ..
cd docker_dir
./build_docker.sh
cd ..
rm -rf sdc
if [ "$?" = "0" ] 
then
   echo 111222
else
   echo "8888888888888"
   exit 1
fi 
