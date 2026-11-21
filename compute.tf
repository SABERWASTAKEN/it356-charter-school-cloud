data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  windows_servers = ["DC01", "DC02", "MSCA01", "NPS01"]
}

resource "aws_instance" "windows_nodes" {
  for_each               = toset(local.windows_servers)
  ami                    = data.aws_ami.windows_2022.id
  instance_type          = "c5.xlarge"
  subnet_id              = aws_subnet.internal_subnet.id
  vpc_security_group_ids = [aws_security_group.internal_sg.id]
  tags                   = { Name = each.key }
}

resource "aws_instance" "linux_external" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.external_subnet.id
  vpc_security_group_ids = [aws_security_group.external_sg.id]
  tags                   = { Name = "Linux-Ext-0${count.index + 1}" }
}

resource "aws_instance" "linux_internal" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.internal_subnet.id
  vpc_security_group_ids = [aws_security_group.internal_sg.id]
  tags                   = { Name = "Linux-Int-0${count.index + 1}" }
}