#Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.basename}-public-rt-1"
  }
}
#Internet access rule for public RTB
resource "aws_route" "internet" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#Local access rule for public RTB
resource "aws_route" "local" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = aws_vpc.main.cidr_block
}

#Create private route table. Nº of RTB is based on requested AZ
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count = var.az_span

  tags = {
    Name = "${var.basename}-private-rt-${count.index}"
  }
}

#Internet access rule for private RTBs
resource "aws_route" "private_internet" {
  count = var.az_span
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw[count.index].id
}

#Local access rule for private RTBs
resource "aws_route" "private_local" {
  count = var.az_span
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = aws_subnet.private[count.index].cidr_block
}
