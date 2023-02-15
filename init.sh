#!/bin/sh
sudo yum update -y && sudo yum install -y
amazon-linux-extras install -y docker
service docker start
usermod -a -G docker ec2-user
pip3 install docker-compose
sudo mkdir -p ~/app
cd ~/app/
wget https://raw.githubusercontent.com/alvarodcr/hello-2048/main/docker-compose.yml
docker-compose up -d
