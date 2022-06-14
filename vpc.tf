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