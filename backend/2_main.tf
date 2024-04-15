provider "aws" {
  region = var.region
}

#Creates a dynamodb table to store a lock preventing any other user run terraform scripts on that infrastructure
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "tflock-${var.basename}"
  billing_mode   = var.billing_mode
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#Create a s3 bucket to store tfstate file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-${var.basename}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "s3-${var.basename}"
  }
}

#Basic networking configuration for s3
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = var.acl
}

#Enables or disables s3 file versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = var.versioning
  }
}

