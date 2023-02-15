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

  provisioner "file" {
    source      = "/home/sinensia/hello-terraform/init.sh"
    destination = "/home/ec2-user/app"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/clave-lucatic.pem")
      host        = aws_instance.app_server.public_ip

    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/app/init.sh",
      "/home/ec2-user/app/init.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/clave-lucatic.pem")
      host        = "${aws_instance.example.public_ip}"
    }
  }


}
