variable "region" {
  description = "The AWS region to deploy all non-global resources"
  type        = string
}

variable "basename" {
  description = "Tag substring for all deployed resources (e.g.: test-dev)"
  type = string
}

variable "billing_mode" {
  description = "Configure billing mode for dynamodb table. Please check AWS references for values"
  type = string
  default = "PAY_PER_REQUEST"
}

variable "acl" {
  description = "Defines the ACL for S3 bucket"
  type = string
  default = "private"
}

variable "versioning" {
  description = "Enables versioning mode for the tfstate stored inside the S3 bucket"
  type = bool
  default = true
}


variable "block_public_acls" {
  type        = bool
  description = "Specifies whether the bucket should block public ACLs. If set to true, the bucket will not allow public access via ACLs."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Specifies whether the bucket should ignore public ACLs. If set to true, it ignores any public ACLs on the bucket."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Specifies whether the bucket should block public bucket policies. If true, the bucket does not allow public access via bucket policies."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Specifies whether the bucket should have public policy restrictions. If set to true, it restricts public policies that could modify the bucket's access level."
  default     = true
}