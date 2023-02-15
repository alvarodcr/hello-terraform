terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0b752bf1df193a6c4"
  instance_type          = "t2.micro"
  key_name               = "clave-lucatic"
  vpc_security_group_ids = ["sg-013c0f1d5466fd440"]

  tags = {
    Name = "hello-terraform"
    APP  = var.instance_app
  }
  provisioner "local-exec" {
    working_dir = "ansible"
    command     = "ansible-playbook -i aws_ec2.yml hello_2048.yml"
  }
}
