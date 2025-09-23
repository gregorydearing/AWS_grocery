terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------
# Networking
# -------------------

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "grocery-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "grocery-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "grocery-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "grocery-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -------------------
# Security Groups
# -------------------

resource "aws_security_group" "ec2_sg" {
  name        = "grocery-ec2-sg"
  description = "Allow SSH, HTTP, and Flask"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask backend"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grocery-ec2-sg"
  }
}

resource "aws_key_pair" "hello_key" {
  key_name   = "hello-key"
  public_key = file("~/Downloads/hello-key.pub")
}

# -------------------
# EC2 Instance
# -------------------

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.hello_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "grocery-web"
  }
}

# -------------------
# RDS PostgreSQL
# -------------------

# Security group for RDS (allow Postgres only from EC2 SG)
resource "aws_security_group" "rds_sg" {
  name        = "grocery-rds-sg"
  description = "Allow Postgres from EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Postgres from EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grocery-rds-sg"
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "grocery-rds-subnet-group"
  subnet_ids = [aws_subnet.public.id]

  tags = {
    Name = "grocery-rds-subnet-group"
  }
}

# RDS PostgreSQL instance
resource "aws_db_instance" "postgres" {
  identifier             = "grocerymate-db"
  allocated_storage      = var.db_allocated_storage
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  publicly_accessible    = false # safer default

  tags = {
    Name = "grocerymate-db"
  }
}

# -------------------
# S3 Buckets
# -------------------

resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars-eunorth1-gregdearing"
  acl    = "private"

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "avatars" {
  bucket = aws_s3_bucket.avatars.id
  versioning_configuration {
    status = "Enabled"
  }
}
