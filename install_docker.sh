#!/bin/sh
sudo yum update -y && sudo yum install -y
sudo amazon-linux-extras install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo pip3 install docker-compose

