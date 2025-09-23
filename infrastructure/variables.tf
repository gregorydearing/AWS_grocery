# -------------------
# AWS Settings
# -------------------
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "availability_zone" {
  description = "AZ for public subnet"
  type        = string
  default     = ""
}

# -------------------
# Networking
# -------------------
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# -------------------
# EC2
# -------------------
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-09278528675a8d54e"
}

# -------------------
# RDS (PostgreSQL)
# -------------------
variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "grocerymate-db"
}

variable "db_username" {
  description = "Master username for PostgreSQL"
  type        = string
  default     = "grocery_user"
}

variable "db_password" {
  description = "Master password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storage allocated to RDS instance (in GB)"
  type        = number
  default     = 20
}

