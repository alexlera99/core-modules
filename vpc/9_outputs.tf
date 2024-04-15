#VPC output
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

#Subnets output
output "public_subnet_ids" {
  description = "List of IDs for public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "List of IDs for private subnets"
  value       = aws_subnet.private.*.id
}

#NACLs output
output "public_network_acl_id" {
  description = "The ID of the public network ACL"
  value       = aws_network_acl.public.id
}

output "private_network_acl_id" {
  description = "The ID of the private network ACL"
  value       = aws_network_acl.private.id
}

# Routing table output
output "public_route_table_ids" {
  description = "List of IDs for public route tables"
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = "List of IDs for private route tables"
  value       = aws_route_table.private.*.id
}
