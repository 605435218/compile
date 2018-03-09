#!/bin/bash
git clone http://10.190.49.99:8080/NFVO.git
mv NFVO/src/so ./
rm -rf NFVO
cd so
mvn install  -Dmaven.test.skip=true
cd ..
cd docker_dir
./build_docker.sh
cd ..
rm -rf so
