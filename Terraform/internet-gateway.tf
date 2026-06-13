resource "aws_internet_gateway" "project4_internet_gateway" {
  vpc_id = aws_vpc.project4_vpc.id

  tags = {
    Name = "project4-internet-gateway"
  }
}