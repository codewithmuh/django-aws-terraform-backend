# Production VPC
resource "aws_vpc" "prod" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Public subnets
resource "aws_subnet" "prod_public_1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.prod.id
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "prod-public-1"
  }
}
resource "aws_subnet" "prod_public_2" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.prod.id
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "prod-public-2"
  }
}

# Private subnets
resource "aws_subnet" "prod_private_1" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.prod.id
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "prod-private-1"
  }
}
resource "aws_subnet" "prod_private_2" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.prod.id
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "prod-private-2"
  }
}

# Route tables and association with the subnets
resource "aws_route_table" "prod_public" {
  vpc_id = aws_vpc.prod.id
}
resource "aws_route_table_association" "prod_public_1" {
  route_table_id = aws_route_table.prod_public.id
  subnet_id      = aws_subnet.prod_public_1.id
}
resource "aws_route_table_association" "prod_public_2" {
  route_table_id = aws_route_table.prod_public.id
  subnet_id      = aws_subnet.prod_public_2.id
}

resource "aws_route_table" "prod_private" {
  vpc_id = aws_vpc.prod.id
}
resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.prod_private.id
  subnet_id      = aws_subnet.prod_private_1.id
}
resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.prod_private.id
  subnet_id      = aws_subnet.prod_private_2.id
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod.id
}
resource "aws_route" "prod_internet_gateway" {
  route_table_id         = aws_route_table.prod_public.id
  gateway_id             = aws_internet_gateway.prod.id
  destination_cidr_block = "0.0.0.0/0"
}

# NAT gateway
resource "aws_eip" "prod_nat_gateway" {
  domain                     = "vpc"
  associate_with_private_ip = "10.0.0.5"
  depends_on                = [aws_internet_gateway.prod]
}
resource "aws_nat_gateway" "prod" {
  allocation_id = aws_eip.prod_nat_gateway.id
  subnet_id     = aws_subnet.prod_public_1.id
}
resource "aws_route" "prod_nat_gateway" {
  route_table_id         = aws_route_table.prod_private.id
  nat_gateway_id         = aws_nat_gateway.prod.id
  destination_cidr_block = "0.0.0.0/0"
}