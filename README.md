# Terraform Multi-Environment AWS Infrastructure

A Terraform-based Infrastructure as Code (IaC) project that provisions and manages separate **Development** and **Production** environments on AWS using a single reusable Terraform configuration.

## 🚀 Project Overview

The main objective of this project is to demonstrate how Terraform can be used to manage multiple AWS environments without maintaining separate Terraform configurations.

The project uses:

* Terraform Workspaces for environment separation
* Variables for reusable configuration
* Separate `.tfvars` files for Dev and Prod
* Data blocks to dynamically retrieve existing AWS resources
* EC2 instances for compute
* S3 for object storage
* Security Groups for network access control
* Terraform outputs for deployment information

### Core Concept

```text
Same Terraform Code
        │
        ├── Dev Workspace
        │      └── terraform.tfvars.dev
        │             └── Smaller Infrastructure
        │
        └── Prod Workspace
               └── terraform.tfvars.prod
                      └── Larger Infrastructure
```

## 🏗️ Architecture

```text
                    Terraform CLI
                         │
                         ▼
                  AWS Provider
                         │
              ┌──────────┴──────────┐
              │                     │
        DEV WORKSPACE         PROD WORKSPACE
              │                     │
       1 × t3.micro          3 × t3.small
       Monitoring: Off       Monitoring: On
              │                     │
              └──────────┬──────────┘
                         │
                         ▼
                       AWS
              ┌─────────────────────┐
              │        EC2          │
              │        S3            │
              │   Security Group    │
              └─────────────────────┘
```

## ☁️ AWS Services Used

| Service            | Purpose                      |
| ------------------ | ---------------------------- |
| EC2                | Compute / virtual servers    |
| S3                 | Object storage               |
| Security Group     | Network traffic control      |
| VPC                | Network environment          |
| Subnets            | Network subdivisions         |
| AMI                | EC2 instance template        |
| Availability Zones | AWS infrastructure locations |

## 🔧 Terraform Concepts Used

### 1. Workspaces

Two Terraform workspaces are used:

* `dev`
* `prod`

Each workspace maintains its own Terraform state, allowing the environments to be managed separately.

### 2. Variables

The project uses multiple Terraform variables to avoid hardcoding configuration values.

Examples include:

* AWS region
* Instance type
* Instance count
* Environment
* Monitoring configuration
* S3 configuration

### 3. Environment-Specific Variables

Different `.tfvars` files are used for each environment.

```text
terraform.tfvars.dev
terraform.tfvars.prod
```

Development uses smaller infrastructure, while Production uses larger infrastructure.

### 4. Data Blocks

Terraform data blocks are used to retrieve existing AWS information dynamically instead of hardcoding resource IDs.

The project uses data blocks for:

* AMI
* VPC
* Subnets
* Availability Zones

### 5. Resources

The project provisions AWS resources including:

* EC2 instances
* S3 bucket
* Security Group

### 6. Outputs

Terraform outputs are used to display useful deployment information such as the EC2 public IP and web URL.

## 📁 Project Structure

```text
terraform-multi-environment-aws/
│
├── main.tf
├── variables.tf
├── terraform.tf
├── outputs.tf
│
├── terraform.tfvars.dev
├── terraform.tfvars.prod
│
├── README.md
└── .gitignore
```

## ⚙️ Prerequisites

Before running the project, install:

* Terraform
* AWS CLI
* An AWS account
* AWS credentials configured on your machine

Check the installations:

```bash
terraform version
aws --version
```

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

## 🚀 Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Format the configuration

```bash
terraform fmt
```

### 3. Validate the configuration

```bash
terraform validate
```

### 4. Create the Dev workspace

```bash
terraform workspace new dev
```

If it already exists:

```bash
terraform workspace select dev
```

### 5. Deploy Development Environment

```bash
terraform plan -var-file="terraform.tfvars.dev"
```

```bash
terraform apply -var-file="terraform.tfvars.dev"
```

### 6. Check Outputs

```bash
terraform output
```

### 7. Switch to Production

```bash
terraform workspace new prod
```

Or:

```bash
terraform workspace select prod
```

### 8. Deploy Production Environment

```bash
terraform plan -var-file="terraform.tfvars.prod"
```

```bash
terraform apply -var-file="terraform.tfvars.prod"
```

## 🔍 Useful Commands

```bash
terraform workspace list
terraform workspace show
terraform validate
terraform fmt
terraform plan
terraform apply
terraform output
terraform show
```

## 🧹 Destroy Infrastructure

To remove the infrastructure from the current workspace:

```bash
terraform destroy -var-file="terraform.tfvars.dev"
```

For production:

```bash
terraform destroy -var-file="terraform.tfvars.prod"
```

**Be careful when running `terraform destroy`, especially in the production workspace.**

## 🎯 Dev vs Production

| Configuration | Dev                 | Prod       |
| ------------- | ------------------- | ---------- |
| Workspace     | `dev`               | `prod`     |
| EC2 Count     | 1                   | 3          |
| Instance Type | `t3.micro`          | `t3.small` |
| Monitoring    | Disabled            | Enabled    |
| S3 Versioning | Suspended/Off       | Enabled    |
| Purpose       | Development/Testing | Production |

## 📌 Key Learning

This project demonstrates how Infrastructure as Code can be used to create reusable and environment-specific AWS infrastructure.

The main idea is:

> **Same Terraform code + different workspace + different variables = different environments.**

## 👨‍💻 Author

**Arjun Sharma**

B.Tech Computer Science Engineering
KIET Group of Institutions
