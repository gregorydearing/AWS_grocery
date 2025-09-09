# GroceryMate AWS Deployment 🚀

## 🏆 GroceryMate E-Commerce Platform on AWS

[![Python](https://img.shields.io/badge/Language-Python-blue)](https://www.python.org/)
[![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)](https://www.postgresql.org/)
[![AWS](https://img.shields.io/badge/AWS-Terraform-orange)](https://aws.amazon.com/)

⭐ **Star this repo** if you find it useful!

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Infrastructure Setup](#-infrastructure-setup)
- [Application Setup](#-application-setup)
- [Usage](#-usage)
- [AWS Cost Considerations](#-aws-cost-considerations)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 Overview

This project demonstrates how to deploy **GroceryMate**, a simple e-commerce application, onto **AWS** using **Terraform**.  
The infrastructure is provisioned in a **single-tier architecture** with:

- **EC2 instance** (running the app with Docker)  
- **RDS PostgreSQL** (database for products & users)  
- **S3 bucket** (for storing user avatars)  
- **Networking (VPC, subnet, Internet Gateway, security groups)**  

The goal is to show practical cloud skills while keeping the design minimal for learning.

---

## 🛒 Features

- **🛡️ Authentication**: Secure user registration & login  
- **🔎 Product browsing** with search/filter  
- **🛍️ Shopping basket** & checkout flow  
- **⭐ Favorites** for users  
- **☁️ Cloud hosting** with AWS + Terraform IaC  

---

## 🏗️ Architecture

Here’s the AWS architecture diagram created for this project:  

![AWS Diagram](https://drive.google.com/uc?export=view&id=11fJrfckB0hW6zeEof8zznq1YHnLDDMkl)

**Key components:**
- **VPC** with one public subnet  
- **EC2 instance** (t3.micro) running the Dockerized application  
- **RDS PostgreSQL database** for backend data  
- **S3 bucket** with versioning enabled for avatar storage  
- **Internet Gateway** for external access  
- **Security Groups** for HTTP (80), Flask app (5000), and SSH (22)  

---

## 📋 Prerequisites

- **Terraform >= 1.3**  
- **AWS CLI** configured with `aws configure`  
- **Docker** installed (for building and testing locally)  
- **PostgreSQL client** (optional for testing DB)  

---

## ⚙️ Infrastructure Setup

1. Clone this repository:
   ```bash
   git clone --branch version2 https://github.com/gregorydearing/AWS_grocery.git
   cd AWS_grocery/infrastructure

### 🔹 Configure PostgreSQL

Before creating the database user, you can choose a custom username and password to enhance security. Replace `<your_secure_password>` with a strong password of your choice in the following commands.

Create database and user:

```sh
psql -U postgres -c "CREATE DATABASE grocerymate_db;"
psql -U postgres -c "CREATE USER grocery_user WITH ENCRYPTED PASSWORD '<your_secure_password>';"  # Replace <your_secure_password> with a strong password of your choice
psql -U postgres -c "ALTER USER grocery_user WITH SUPERUSER;"
```

### 🔹 Populate Database

```sh
psql -U grocery_user -d grocerymate_db -f backend/app/sqlite_dump_clean.sql
```

Verify insertion:

```sh
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM users;"
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM products;"
```

### 🔹 Set Up Python Environment


Install dependencies in an activated virtual Enviroment:

```sh
cd backend
pip install -r requirements.txt
```
OR (if pip doesn't exist)
```sh
pip3 install -r requirements.txt
```

### 🔹 Set Environment Variables

Create a `.env` file:

```sh
touch .env  # macOS/Linux
ni .env -Force  # Windows
```

Generate a secure JWT key:

```sh
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Update `.env`:

```sh
nano .env
```

Fill in the following information (make sure to replace the placeholders):

```ini
JWT_SECRET_KEY=<your_generated_key>
POSTGRES_USER=grocery_user
POSTGRES_PASSWORD=<your_password>
POSTGRES_DB=grocerymate_db
POSTGRES_HOST=localhost
POSTGRES_URI=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:5432/${POSTGRES_DB}
```

### 🔹 Start the Application

```sh
python3 run.py
```

## 📖 Usage

- Access the application at [http://localhost:5000](http://localhost:5000)
- Register/Login to your account
- Browse and search for products
- Manage favorites and shopping basket
- Proceed through the checkout process

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository.
2. Create a new feature branch (`feature/your-feature`).
3. Implement your changes and commit them.
4. Push your branch and create a pull request.

## 📜 License

This project is licensed under the MIT License.




