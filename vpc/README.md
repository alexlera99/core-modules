# AWS VPC Terraform Module

This module provisions a complete Virtual Private Cloud (VPC) environment in AWS, including subnets, network ACLs, routing tables, and flow logs.

## Features

- **VPC Creation**: Set up a fully configured VPC.
- **Subnet Deployment**: Configure both public and private subnets across multiple availability zones.
- **Network ACLs**: Set up ACLs with predefined rules for both ingress and egress traffic.
- **Routing Tables**: Associate subnets with specific routing tables for managing traffic routing.
- **Flow Logs**: Enable flow logging for VPCs and subnets to capture information about IP traffic.

## Requirements

- Terraform version `>= 1.0.0, < 1.6.0`
- AWS Provider version `>= 5.22.0, < 6.0.0`
- Custom s3 backend version `>= 1.0.0`

## Usage

To use this module, include it in your Terraform configuration with the necessary variables:

```hcl
module "aws_vpc" {
  source = "path/to/module" 
  # Please see: https://developer.hashicorp.com/terraform/language/modules/sources
      # for how to use a source line with tags

  region         = "us-west-2"
  basename       = "myproject"
```

# Variables

- **region**: The AWS region to deploy all non-global resources.
- **basename**: A substring used to tag all deployed resources, aiding in identification across different environments, such as `test-dev`.

- **bucket**: The ID of the S3 bucket used to store the Terraform state. This ID is typically obtained from the backend module outputs.

- **tfstate_path**: Specifies the absolute path for the Terraform state file location, e.g., `/home/linux/terraform/`.

- **dynamodb**: The ID of the DynamoDB table used for state locking, obtained from backend module outputs.

- **backend_acl**: The ACL setting required for the backend configuration, retrieved from backend module outputs.

- **vpc_cidr_block**: The CIDR block for the VPC. Default value is `10.1.1.0/24`.

- **vpc_cidr_length**: The length of the CIDR block used for the VPC. Default value is `24`.

- **enable_dns_hostnames**: Enables or disables DNS hostnames within the VPC. This is important for services that rely on DNS for communication within the VPC. Default is `false`.

- **retention_in_days**: The number of days to retain VPC flow logs for security and network troubleshooting. Default is `7`.

- **az_span**: The number of Availability Zones the VPC will span across. This affects the distribution and resilience of the network resources. Default is `3`.

- **cidrsubnet_newbits**: The number of bits by which to extend the CIDR block for creating subnets. This determines how many subnets can be created from the base CIDR block. Default is `1`.

- **domain_name**: An optional domain name used by default for resolving non-Fully Qualified Domain Names within the VPC. This is useful for internal network configurations.

### ACL Rules

The module configures various network ACL rules, categorized as follows:

- **Traffic Within the VPC**:
    - `1100`: All internal VPC traffic
    - `1110`: SSH traffic within the VPC
    - `1120`: HTTP traffic within the VPC
    - `1130`: HTTPS traffic within the VPC

- **Inbound Traffic from the Internet**:
    - `1200`: All inbound traffic from the internet
    - `1210`: Inbound SSH from the internet
    - `1220`: Inbound HTTP from the internet
    - `1230`: Inbound HTTPS from the internet

- **Outbound Traffic to the Internet**:
    - `1300`: All outbound traffic to the internet
    - `1310`: Outbound SSH to the internet
    - `1320`: Outbound HTTP to the internet
    - `1330`: Outbound HTTPS to the internet

- **Database Traffic**:
    - `1400`: General database access within VPC
    - `1410`: SQL database traffic
    - `1420`: NoSQL database traffic

- **Special Services**:
    - `1500`: DNS services
    - `1510`: DHCP traffic
    - `1520`: Custom applications specific to your organization

### ACL Configuration Variables

- **public_nacls_egress**: List of egress rules for the public network ACL. Defaults to allowing outbound TCP traffic to the internet on port 443 from all sources.
    - Default:
        - `rule_number`: `1300`
        - `action`: `allow`
        - `protocol`: `tcp`
        - `from_port`: `443`
        - `to_port`: `443`
        - `cidr_block`: `0.0.0.0/0`

- **public_nacls_ingress**: List of ingress rules for the public network ACL. Defaults to allowing inbound TCP traffic on port 443 from all sources.
    - Default:
        - `rule_number`: `1200`
        - `action`: `allow`
        - `protocol`: `tcp`
        - `from_port`: `443`
        - `to_port`: `443`
        - `cidr_block`: `0.0.0.0/0`

- **private_nacls_egress**: List of egress rules for the private network ACL. Defaults to allowing outbound TCP traffic to the internet on port 443 from all sources.
    - Default:
        - `rule_number`: `1300`
        - `action`: `allow`
        - `protocol`: `tcp`
        - `from_port`: `443`
        - `to_port`: `443`
        - `cidr_block`: `0.0.0.0/0`

- **private_nacls_ingress**: List of ingress rules for the private network ACL. Defaults to allowing inbound TCP traffic on port 443 from a specific IP address.
    - Default:
        - `rule_number`: `1501`
        - `action`: `allow`
        - `protocol`: `tcp`
        - `from_port`: `443`
        - `to_port`: `443`
        - `cidr_block`: `1.2.3.4/32`

# Outputs

After deploying the Terraform module for AWS VPC, the following outputs will be available. These outputs provide key details about the resources created, enabling further integration or management within your AWS environment.

- **vpc_id**: The unique identifier of the VPC that has been created.

- **vpc_cidr_block**: The CIDR block allocated to the VPC, defining the IP range of the network.

- **public_subnet_ids**: List of identifiers for all public subnets created within the VPC. Public subnets typically have direct access to the Internet.

- **private_subnet_ids**: List of identifiers for all private subnets created within the VPC. Private subnets are used for resources that do not require direct access to the Internet.

- **public_network_acl_id**: The identifier for the network access control list (ACL) associated with the public subnets, managing inbound and outbound traffic rules.

- **private_network_acl_id**: The identifier for the network ACL associated with the private subnets, managing traffic flow to and from these subnets.

- **public_route_table_ids**: Identifiers for the route tables associated with public subnets, which contain rules for routing traffic from the public subnets to external destinations.

- **private_route_table_ids**: Identifiers for the route tables associated with private subnets, used to control traffic flow from the private subnets based on predefined routing rules.
