#Create IGW. Default routing for internet access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.basename}-vpc"
  }
}