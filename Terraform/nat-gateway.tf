resource "aws_eip" "project4_eip" {
  domain = "vpc"
}



resource "aws_nat_gateway" "project4_nat_gateway" {
  allocation_id = aws_eip.project4_eip.id
  subnet_id     = aws_subnet.project4_public_subnet_1.id

  tags = {
    Name = "project4-nat-gateway"
  }
}