output "acl" {
  value = "private"
  description = "Defines if ACL is needed for S3 bucket"
}

output "bucket" {
  value = aws_s3_bucket.terraform_state.id
  description = "The S3 bucket id"
}

output "dynamodb" {
  value = aws_dynamodb_table.terraform_locks.id
  description = "The dynamodb table id"
}