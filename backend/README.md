# Terraform Module for S3-Backed State Management

This Terraform module provisions an S3 bucket specifically configured to store Terraform state files securely, along with a DynamoDB table for state locking to ensure state consistency.

## Features

- **S3 Bucket for Terraform State**: Configures an S3 bucket with best practices for privacy and security, including blocking public access and enabling versioning.
- **DynamoDB Table for State Locking**: Uses a DynamoDB table to lock the state file during modification to prevent conflicts.

## Requirements

- Terraform version `>= 1.0.0, < 1.6.0`
- AWS Provider version `>= 5.22.0, < 6.0.0`

## Usage

To use this module in your Terraform configuration, follow these steps:

1. **Add the Module to Your Terraform Configuration:**
 ```hcl
    module "terraform_state" {
      source  = "path/to/module" 
      #Please see: https://developer.hashicorp.com/terraform/language/modules/sources
      # for how to use a source line with tags

      region              = "us-west-2"
      basename            = "myproject-dev"
      ...
    }
 ```

2. **Initialize Terraform:**

   Run `terraform init` to initialize the configuration and download the required providers.

3. **Apply the Configuration:**

   Run `terraform apply` to create the resources.

## Variables

- **region**: The AWS region to deploy all non-global resources.
- **basename**: Tag substring for all deployed resources (e.g., `myproject-dev`).
- **billing_mode**: Configure billing mode for the DynamoDB table. Valid values are typically `PROVISIONED` or `PAY_PER_REQUEST`.
- **acl**: Defines the ACL for the S3 bucket. Default is `private`.
- **versioning**: Enables versioning mode for the tfstate stored inside the S3 bucket. Default is `true`.
- **block_public_acls**: Specifies whether the bucket should block public ACLs. Default is `true`.
- **ignore_public_acls**: Specifies whether the bucket should ignore public ACLs. Default is `true`.
- **block_public_policy**: Specifies whether the bucket should block public bucket policies. Default is `true`.
- **restrict_public_buckets**: Specifies whether the bucket should have public policy restrictions. Default is `true`.

## Outputs

This module will output the following details upon successful creation:

- **s3_bucket_id**: The ID of the S3 bucket used for storing the Terraform state.
- **dynamodb_table_name**: The name of the DynamoDB table used for state locking.
- **acl**: The ACL method for s3. Currently, only private is supported.