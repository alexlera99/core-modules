variable "region" {
  description = "The AWS region to deploy all non-global resources"
  type        = string
}

variable "basename" {
  description = "Tag substring for all deployed resources (e.g.: test-dev)"
}

variable "bucket" {
  description = "The ID from S3 bucket. You can retrieve it from backend module outputs"
  type = string
}

variable "tfstate_path" {
  description = "The absolute path reference for your tfstate location. e.g: /home/linux/terraform/"
  type = string
}

variable "dynamodb" {
  description = "The ID from your dynamodb. You can retrieve it from backend module outputs"
  type = string
}

variable "backend_acl" {
  description = "ACL line needed for backend. You can retrieve it from backend module outputs"
  type = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.1.0/24"
}

variable "vpc_cidr_length" {
  description = "Length of the requested CIDR block"
  type        = number
  default     = 24
}

variable "enable_dns_hostnames" {
  description = "Boolean to enable/disable DNS hostnames in VPC"
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "Number of days flow logs should be retained"
  type = number
  default = 7
}

variable "az_span" {
  description = "Number of availability zones deployed"
  type        = number
  default     = 3
}

variable "cidrsubnet_newbits" {
  description = "Quantity you want to shrink your CIDR length for each subnet"
  type = number
  default = 1
}

variable "domain_name" {
  description = "Optional suffix domain name used by default when resolving non Fully Qualified Domain Names (FQDNs)."
  type = string
}

#Traffic Within the VPC: X1XX
#1100: All internal VPC traffic
#1110: SSH traffic within the VPC
#1120: HTTP traffic within the VPC
#1130: HTTPS traffic within the VPC
#
#Inbound Traffic from the Internet: X2XX
#1200: All inbound traffic from the internet
#1210: Inbound SSH from the internet
#1220: Inbound HTTP from the internet
#1230: Inbound HTTPS from the internet
#
#Outbound Traffic to the Internet: X3XX
#1300: All outbound traffic to the internet
#1310: Outbound SSH to the internet
#1320: Outbound HTTP to the internet
#1330: Outbound HTTPS to the internet
#
#Database Traffic: X4XX
#1400: General database access within VPC
#1410: SQL database traffic
#1420: NoSQL database traffic
#
#Special Services: X5XX
#1500: DNS services
#1510: DHCP traffic
#1520: Custom applications specific to your organization

variable "public_nacls_egress" {
  description = "List of egress rules for the public network ACL"
  type = list(object({
    rule_number    = number
    action         = string
    protocol       = string
    from_port      = number
    to_port        = number
    cidr_block     = string
    icmp_code      = number
    icmp_type      = number
    egress         = bool
  }))
  default = [
    {
      rule_number = 1300,
      action      = "allow",
      protocol    = "tcp",
      from_port   = 443,
      to_port     = 443,
      cidr_block  = "0.0.0.0/0",
      icmp_code   = null,
      icmp_type   = null,
      egress      = true
    },
  ]
}

variable "public_nacls_ingress" {
  description = "List of ingress rules for the public network ACL"
  type = list(object({
    rule_number    = number
    action         = string
    protocol       = string
    from_port      = number
    to_port        = number
    cidr_block     = string
    icmp_code      = number
    icmp_type      = number
    egress         = bool
  }))
  default = [
    {
      rule_number = 1500,
      action      = "allow",
      protocol    = "tcp",
      from_port   = 443,
      to_port     = 443,
      cidr_block  = "0.0.0.0/0",
      icmp_code   = null,
      icmp_type   = null,
      egress      = false
    },
  ]
}

variable "private_nacls_egress" {
  description = "List of egress rules for the private network ACL"
  type = list(object({
    rule_number    = number
    action         = string
    protocol       = string
    from_port      = number
    to_port        = number
    cidr_block     = string
    icmp_code      = number
    icmp_type      = number
    egress         = bool
  }))
  default = [
    {
      rule_number = 1300,
      action      = "allow",
      protocol    = "tcp",
      from_port   = 443,
      to_port     = 443,
      cidr_block  = "0.0.0.0/0",
      icmp_code   = null,
      icmp_type   = null,
      egress      = true
    },
  ]
}

variable "private_nacls_ingress" {
  description = "List of ingress rules for the private network ACL"
  type = list(object({
    rule_number    = number
    action         = string
    protocol       = string
    from_port      = number
    to_port        = number
    cidr_block     = string
    icmp_code      = number
    icmp_type      = number
    egress         = bool
  }))
  default = [
    {
      rule_number = 1501,
      action      = "allow",
      protocol    = "tcp",
      from_port   = 443,
      to_port     = 443,
      cidr_block  = "1.2.3.4/32",
      icmp_code   = null,
      icmp_type   = null,
      egress      = false
    },
  ]
}
