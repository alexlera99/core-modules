#Create NGW routing traffic between public subnets and private subnets. nº of ngw is based on AZ requested
resource "aws_nat_gateway" "ngw" {
  count = var.az_span
  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.basename}-ngw-${count.index}"
  }
}

#Create an elastic ip for every NGW
resource "aws_eip" "ngw" {
  count = var.az_span

  tags = {
    Name = "${var.basename}-eip-ngw-${count.index}"
  }
}