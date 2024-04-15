terraform {
  required_version = ">= 1.0.0, < 1.6.0"

  required_providers {
    aws = {
      source = "registry.terraform.io/hashicorp/aws"
      version = ">= 5.22.0, < 6.0.0"
    }
  }

  backend "s3" {
    bucket = var.bucket
    key = "${var.tfstate_path}/terraform.tfstate"
    region = var.region
    encrypt = true
    dynamodb_table = var.dynamodb
    acl = var.backend_acl
  }
}