# variables.tf

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "ami" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0f9708d1cd2cfee41"  # Ubuntu 22.04
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}
