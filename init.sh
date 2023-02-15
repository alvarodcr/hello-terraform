#!/bin/sh
sudo yum update -y && sudo yum install -y
sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo pip3 install docker-compose                                
mkdir /home/ec2-user/app
cd /home/ec2-user/app
wget https://raw.githubusercontent.com/alvarodcr/hello-2048/main/docker-compose.yml
docker-compose pull
docker-compose up -d

