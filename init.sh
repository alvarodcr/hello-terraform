#!/bin/sh
mkdir /home/ec2-user/app
cd /home/ec2-user/app
wget https://raw.githubusercontent.com/alvarodcr/hello-2048/main/docker-compose.yml
docker-compose pull
docker-compose up -d

