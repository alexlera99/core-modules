data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

#Creates a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "vpc-${var.basename}"
  }
}

resource "aws_vpc_dhcp_options" "dopt_vpc" {
  domain_name = var.domain_name
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "dopt-${var.basename}-vpc"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dopt_vpc.id
}