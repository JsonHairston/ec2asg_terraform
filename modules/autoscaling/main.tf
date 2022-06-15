## Creating Instance Resources
resource "aws_launch_configuration" "terraform_config" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  security_groups        = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  
  user_data = file("apache.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform_asg" {
  name                 = "terraform-asg-example"
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
  launch_configuration = aws_launch_configuration.terraform_config.name
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  force_delete         = true


  lifecycle {
    create_before_destroy = true
  }
}

## Create a VPC
resource "aws_vpc" "testvpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.testvpc.id
  cidr_block = var.vpc_cidr

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_internet_gateway" "testigw" {
  vpc_id = aws_vpc.testvpc.id

  tags = {
    Name = "TestIGW"
  }
}

resource "aws_route_table" "newtestrt" {
  vpc_id = aws_vpc.testvpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testigw.id
    }

  tags = {
    Name = "NewTestRT"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.newtestrt.id
}

## Security groups
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.testvpc.id
  

  ingress {
    description = "Allow traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description = "Allow traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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