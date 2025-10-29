variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

# ✅ Optional flags to control creation of resources dynamically
variable "create_vpc" {
  description = "Whether to create a VPC"
  type        = bool
  default     = true
}

variable "create_s3" {
  description = "Whether to create an S3 bucket"
  type        = bool
  default     = false
}

variable "create_lb" {
  description = "Whether to create a Load Balancer"
  type        = bool
  default     = false
}

variable "create_lambda" {
  description = "Whether to create a Lambda function"
  type        = bool
  default     = false
}
