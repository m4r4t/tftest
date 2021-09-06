terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfFqN6l/UN4XQkqmzOMHXM4vy9uIDYndbQW9R+8GLMIjANcAaIA/4udo1eae9HvcKAf+vBGZxTlUZRADmV1uM1+/ITrySadws1KVYPD4B/oNg/8wop0OOuzZasxIC2V/OuL/Vn53ZN/blmD+Z+WPIL4pp1pil1XsPP6UpgSPwlXPzsI/dOyy8LBgJh0eV3fAE1APv9kpDhsUQFVTDU81c3bNctHxFolOZBS4HzJFsp6VlpNdos37mZs0vAKmYNexh5i+oYF32G5IfLuTX3F8X4VCpJGb1xf2Zwrz9kefFwTH1cxovXqqbsvDJevxmn9nAxG6rp/1ps6oB/zbK0vpZK4kH5ZHGvqobIwBm0sOyjRRI2DmYkiIPAR8cc5lmF3YdC35HyKoNKwNYvDUgxWHO4zxPKBFt7yJKYoIfyCywa1zmrmXWJMMvKJ0fuLhYYmOJ4u1SH8LwNKHFE/9QVJgFETOam0R/LrbnfgxQOZysw08/7hkBI47cViABRX41+ML0= m4k3@u51"
}

resource "aws_security_group" "example" {
 

  ingress  {
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  ingress  {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    } 

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }  
}


resource "aws_instance" "app_server" {
  ami           = "ami-0a8e758f5e873d1c1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = var.instance_name
  }
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF
}

