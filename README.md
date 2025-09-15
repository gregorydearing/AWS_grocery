# GroceryMate AWS E-Commerce Platform

[![Python](https://img.shields.io/badge/Language-Python%2C%20JavaScript-blue)](https://www.python.org/)
[![OS](https://img.shields.io/badge/OS-Linux%2C%20Windows%2C%20macOS-green)](https://www.kernel.org/)
[![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)](https://www.postgresql.org/)
[![Free](https://img.shields.io/badge/Free_for_Non_Commercial_Use-brightgreen)](#license)

⭐ **Star us on GitHub** — it motivates us a lot!

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture Diagram](-#-architecture-diagram)
- [Screenshots & Demo](#-screenshots--demo)
- [Infrastructure Setup](-#-infrastructure-setup)
- [PostgreSQL Setup](#-postgresql-setup)
- [Docker & Backend Setup](#-docker--backend-setup)
- [Usage](#-usage)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 Overview

GroceryMate is an e-commerce platform developed as part of the Masterschools program.  
It is a full-featured grocery shopping application with a modern user interface, secure backend, and scalable AWS infrastructure managed by Terraform.

---

## 🛒 Features

- **🛡️ User Authentication**: Secure registration, login, and session management  
- **🔎 Product Search & Filtering**: Browse products, apply filters, and sort by category or price  
- **⭐ Favorites Management**: Save preferred products  
- **🛍️ Shopping Basket**: Add, view, modify, and remove items  
- **💳 Checkout Process**: Multiple payment options and automatic total calculation  
- **☁️ AWS Infrastructure**: EC2, VPC, S3, and RDS for scalable deployment  

---

## 🖼️ Architecture Diagram

Here’s the AWS architecture diagram created for this project:

<div align="center">
  <img width="761" height="1079" alt="GroceryMate_AWS_Architecture drawio" src="https://github.com/user-attachments/assets/0a43394a-79ba-453e-8834-2f78e0dfb172" />
</div>

> This diagram shows all major AWS resources (VPC, Subnets, EC2, S3, and RDS) and how they connect.

---

## 📸 Screenshots & Demo

![imagen](https://github.com/user-attachments/assets/ea039195-67a2-4bf2-9613-2ee1e666231a)
![imagen](https://github.com/user-attachments/assets/a87e5c50-5a9e-45b8-ad16-2dbff41acd00)
![imagen](https://github.com/user-attachments/assets/589aae62-67ef-4496-bd3b-772cd32ca386)
![imagen](https://github.com/user-attachments/assets/2772b85e-81f7-446a-9296-4fdc2b652cb7)

---

## ⚙️ Infrastructure Setup

All Terraform code is in the `infrastructure` folder:

- `main.tf` – main resources (VPC, subnet, EC2)  
- `variables.tf` – input variables for your AWS region, CIDR blocks, AMI, and instance type  
- `outputs.tf` – outputs like EC2 public IP and S3 bucket name  
- `s3.tf` – S3 bucket configuration  

### 1. Clone Repository

```bash
git clone --branch version2 https://github.com/gregorydearing/AWS_grocery.git
cd AWS_grocery/infrastructure
````

### 2. Prepare Terraform Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
aws_region          = "eu-north-1"
availability_zone   = ""                 
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
instance_type       = "t3.micro"
ami_id              = "ami-09278528675a8d54e"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the Infrastructure

```bash
terraform plan
```

Terraform will show which resources will be created:

* VPC & Public Subnet (`main.tf`)
* Internet Gateway & Route Table (`main.tf`)
* Security Group (`main.tf`)
* EC2 Instance (`main.tf`)
* S3 Bucket (`s3.tf`)

### 5. Apply the Infrastructure

```bash
terraform apply
```

Confirm the action. Terraform will create the resources listed above. Outputs include EC2 public IP, security group ID, and S3 bucket name.

### 6. Connect to EC2

```bash
ssh -i ~/Downloads/hello-key ec2-user@<EC2_PUBLIC_IP>
```

---

## 📋 PostgreSQL Setup

### Local Setup (Optional)

Before creating the database user, choose a secure password:

```bash
psql -U postgres -c "CREATE DATABASE grocerymate_db;"
psql -U postgres -c "CREATE USER grocery_user WITH ENCRYPTED PASSWORD '<your_secure_password>';"
psql -U postgres -c "ALTER USER grocery_user WITH SUPERUSER;"
```

Populate the database:

```bash
psql -U grocery_user -d grocerymate_db -f backend/app/sqlite_dump_clean.sql
```

Verify:

```bash
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM users;"
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM products;"
```

### AWS RDS Setup (Optional)

* Create a PostgreSQL RDS instance in the same VPC as your EC2
* Allow inbound traffic on port 5432 from your EC2 security group
* Connect and verify:

```bash
psql -h <RDS_ENDPOINT> -U grocery_user -d grocerymate_db
```

* Update `.env` file with the RDS endpoint

---

## 🐳 Docker & Backend Setup

### 1. Install Docker on EC2

```bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
docker --version
```

### 2. Clone Backend Repository

```bash
git clone --branch version2 https://github.com/gregorydearing/AWS_grocery.git
cd AWS_grocery/backend
```

### 3. Set Environment Variables

Create `.env`:

```bash
touch .env
```

Fill in:

```env
JWT_SECRET_KEY=<your_generated_key>
POSTGRES_USER=grocery_user
POSTGRES_PASSWORD=<your_password>
POSTGRES_DB=grocerymate_db
POSTGRES_HOST=<your_rds_endpoint_or_localhost>
POSTGRES_URI=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:5432/${POSTGRES_DB}
```

### 4. Build and Run Docker Container

```bash
docker build -t grocerymate-backend .
docker run -d --env-file .env -p 5000:5000 grocerymate-backend
```

---

## 🌐 Usage

Visit: `http://<EC2_PUBLIC_IP>:5000`

* Register/Login
* Browse and search products
* Manage favorites and shopping basket
* Checkout

> Database starts empty; use local or RDS setup to populate.

---

## 🧑‍💻 Contributing

* Fork the repository
* Create a feature branch (`feature/your-feature`)
* Implement changes and commit
* Push and create a pull request

---

## 📜 License

MIT License

---

This repository and documentation were developed during the Masterschool program (2025), with special thanks to Alejandro Roman Ibanez and the support of all GroceryMate teammates.
