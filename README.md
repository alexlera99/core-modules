# Terraform Modules for AWS Infrastructure

This repository contains Terraform modules designed to simplify the provisioning of resources in AWS. Each module serves a specific purpose within your infrastructure.

## Modules

### 1. VPC Module

The VPC module creates a fully featured Virtual Private Cloud (VPC) designed to house your AWS resources. It includes subnets, route tables, network ACLs, and security settings tailored for both public and private network architectures.

**Location**: `core-modules/vpc`

### 2. Backend Module

The backend module provisions an S3 bucket and a DynamoDB configured for storing state files. It includes best practices for security and data retention.

**Location**: `core-modules/backend`

### Quick Start

Here's a quick example to include these modules in your Terraform project:

```hcl
module "my_vpc" {
  source = "./core-modules/vpc"
  region = "us-west-2"
  basename = "myapp"
}

module "my_s3_bucket" {
  source = "./core-modules/backend"
  bucket_name = "myapp-bucket"
  region = "us-east-1"
}