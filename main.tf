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

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "MC_SG" {
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]           #Variable에 넣고 바꿀 수 있음. "[${var.admin_ip}/32"]
    }
    ingress {
        description = "Minecraft Server Port"
        from_port   = 25565
        to_port     = 25567                 #25566, 25567. 추후 오토스케일링으로 서버 특정 인원 늘어나면 자동으로 늘어날 예정.
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