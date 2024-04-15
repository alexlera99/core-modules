data aws_availability_zones "available" {
  state = "available"
}

#Creates n subnets based on nº of requested availability zones
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  count  = var.az_span
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = cidrsubnet(cidrsubnet(aws_vpc.main.cidr_block, 1, 0), var.cidrsubnet_newbits, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.basename}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  count  = var.az_span
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = cidrsubnet(cidrsubnet(aws_vpc.main.cidr_block, 1, 1), var.cidrsubnet_newbits, count.index)

  tags = {
    Name = "${var.basename}-private-subnet-${count.index}"
  }
}