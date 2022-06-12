terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "testvpc" {
  cidr_block = "10.10.0.0/16"
}

#Create subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.testvpc.id
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "PublicSubnet"
  }
}

#Security groups
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.testvpc.id

  ingress {
    description      = "Allow traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

#Create internet gateway
resource "aws_internet_gateway" "testigw" {
  vpc_id = aws_vpc.testvpc.id

  tags = {
    Name = "TestIGW"
  }
}

#Routing table
resource "aws_route_table" "newtestrt" {
  vpc_id = aws_vpc.testvpc.id
    
 tags = {
    Name = "NewTestRT"
 }
} 

#   user_data = filebase64("${path.module}/apache.sh")
# }
resource "aws_instance" "testserver" {
  ami = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  
  monitoring = true
  
  user_data = "${file("apache.sh")}"
  
  tags = {
    name = "testServer"
  }
  
}