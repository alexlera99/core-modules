# Enables service to assume flow logs new roles
data "aws_iam_policy_document" "vpc_flog_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Enables permissions to put events only on created resources
data "aws_iam_policy_document" "vpc_flog_cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [aws_cloudwatch_log_group.vpc.arn]
  }
}

#Policy enforcing log encryption
data "aws_iam_policy_document" "kms_cloudwatch_policy" {
  statement {
    sid = "Enable IAM User permissions"
    actions = [ "kms:*" ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Allow CloudWatch Logs encryption"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    resources = [
      "*"
    ]
  }
}

#Create flog log resources over cloudwatch
resource "aws_iam_role" "vpc_flog_cloudwatch" {
  name               = "${var.basename}_${aws_vpc.main.id}_flog_role_id"
  assume_role_policy = data.aws_iam_policy_document.vpc_flog_assume_role.json
}

#Create KMS key for log encryption. Managed by AWS
resource "aws_kms_key" "cloudwatch_log_group_key" {
  description = "Key for log encryption"
  enable_key_rotation = "true"
  policy = data.aws_iam_policy_document.kms_cloudwatch_policy.json
}

resource "aws_cloudwatch_log_group" "vpc" {
  name = "${var.basename}_${aws_vpc.main.id}_log_group"
  retention_in_days = var.retention_in_days
  kms_key_id = aws_kms_key.cloudwatch_log_group_key.arn

  tags = {
    Name = "cwlg-${var.basename}-vpc"
  }
}

#Create flow log for the VPC collecting all traffic related logs
resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.vpc_flog_cloudwatch.arn
  log_destination = aws_cloudwatch_log_group.vpc.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = {
    Name = "flog-${var.basename}-vpc"
  }
}