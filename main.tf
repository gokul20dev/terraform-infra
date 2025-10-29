provider "aws" {
  region = var.aws_region
}

# ----------------------------
# VPC (created only if create_vpc = true)
# ----------------------------
resource "aws_vpc" "main" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

# ----------------------------
# EC2 Instance (created only if create_ec2 = true)
# ----------------------------
resource "aws_instance" "web" {
  count         = var.create_ec2 ? 1 : 0
  ami           = "ami-00af95fa354fdb788"
  instance_type = var.instance_type
  subnet_id     = "subnet-02b97d710d4383f60"

  tags = {
    Name = "Terraform-Instance"
  }
}

# ----------------------------
# Optional: Random ID for S3
# ----------------------------
resource "random_id" "bucket_id" {
  count       = var.create_s3 ? 1 : 0
  byte_length = 4
}

# ----------------------------
# Optional: S3 Bucket (created only if create_s3 = true)
# ----------------------------
resource "aws_s3_bucket" "example" {
  count  = var.create_s3 ? 1 : 0
  bucket = "${var.vpc_name}-bucket-${random_id.bucket_id[0].hex}"

  tags = {
    Name = "Terraform-S3"
  }
}

# ----------------------------
# Optional: Load Balancer (created only if create_lb = true)
# ----------------------------
resource "aws_lb" "app_lb" {
  count              = var.create_lb ? 1 : 0
  name               = "terraform-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = ["subnet-02b97d710d4383f60"]

  tags = {
    Name = "Terraform-LB"
  }
}

# ----------------------------
# Optional: Lambda Function (created only if create_lambda = true)
# ----------------------------
resource "aws_lambda_function" "example_lambda" {
  count         = var.create_lambda ? 1 : 0
  filename      = "lambda_function_payload.zip"
  function_name = "example_lambda_function"
  role          = "arn:aws:iam::123456789012:role/lambda-ex"  # Replace this with a valid IAM role
  handler       = "index.handler"
  runtime       = "python3.9"

  tags = {
    Name = "Terraform-Lambda"
  }
}
