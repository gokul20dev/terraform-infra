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
  ami           = "ami-00af95fa354fdb788" # example Amazon Linux 2 AMI for ap-south-1
  instance_type = var.instance_type
  subnet_id     = "subnet-02b97d710d4383f60"
  tags = {
    Name = "Terraform-Instance"
  }
}
