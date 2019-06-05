#!/bin/bash

project_path=$(pwd)/../

echo $project_path

docker_image_name=xiaominfc/centos_tt_run

if [ -n "$1" ]; then
    docker_image_name=$1
fi
docker_file=./Dockerfile_run

docker kill $(docker ps -q)

image=$(docker images -q $docker_image_name 2> /dev/null)

if [ "$image" == ""  ];then
    docker build --rm -t $docker_image_name -f $docker_file . 
fi

if [ ! -d mysql_data ];then
    mkdir -p ./mysql_data
fi
chmod 777 ./mysql_data

mysql_data_dir=$(pwd)/mysql_data
supervisor_confs_dir=$(pwd)/supervisor_confs

docker run -d  --privileged=true -v "$project_path/docker/im_server:/opt/im_server" -v "$mysql_data_dir:/var/lib/mysql"  -v "$supervisor_confs_dir:/etc/supervisord.d"    -p 13306:3306/tcp -p 18080:8080/tcp -p 18400:8400/tcp -p 18200:8200/tcp -p 18700:8700/tcp -p 18000:8000/tcp  $docker_image_name
docker exec -it $(docker ps -q) /bin/bash

