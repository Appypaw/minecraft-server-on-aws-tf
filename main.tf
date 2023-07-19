terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.server_region
}

resource "aws_vpc" "MinecraftVPC" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ServerSubnet" {
  vpc_id            = aws_vpc.MinecraftVPC.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.server_availability_zones
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MinecraftVPC.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.MinecraftVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.ServerSubnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "SG" {
  name_prefix = "SG"
  description = "Server security group"
  vpc_id      = aws_vpc.MinecraftVPC.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_ip}/32"]
  }
  ingress {
    description = "Minecraft Server Port"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all TCP traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all UDP traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_server" {
  ami           = "ami-0ea4d4b8dc1e46212" # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  instance_type = var.instance_type

  tags = {
    Name = var.server_name
  }

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.SG.id]
  subnet_id              = aws_subnet.ServerSubnet.id
  
  user_data = <<-EOT
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-1.8.0-openjdk
              mkdir minecraft-server
              cd minecraft-server
              wget -O minecraft_server.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
              java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui
              EOT
}

output "minecraft_server_public_ip" {
  value = aws_instance.minecraft_server.public_ip
}