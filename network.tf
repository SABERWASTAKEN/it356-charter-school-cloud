resource "aws_vpc" "school_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "CharterSchool-VPC" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.school_vpc.id
  tags   = { Name = "CharterSchool-IGW" }
}

resource "aws_subnet" "external_subnet" {
  vpc_id                  = aws_vpc.school_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags                    = { Name = "External-Public-Subnet" }
}

resource "aws_subnet" "internal_subnet" {
  vpc_id            = aws_vpc.school_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"
  tags              = { Name = "Internal-Private-Subnet" }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.external_subnet.id
  tags          = { Name = "CharterSchool-NAT" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.school_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.external_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.school_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.internal_subnet.id
  route_table_id = aws_route_table.private_rt.id
}