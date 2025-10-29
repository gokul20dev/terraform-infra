provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0e8a34246278c21e4" # example Amazon Linux 2 AMI for ap-south-1
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  tags = {
    Name = "Terraform-Instance"
  }
}
