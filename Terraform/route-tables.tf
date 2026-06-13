resource "aws_route_table" "project4_public_route_table" {
  vpc_id = aws_vpc.project4_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project4_internet_gateway.id
  }

  tags = {
    Name = "project4_public_route_table"
  }
}


resource "aws_route_table" "project4_private_route_table" {
  vpc_id = aws_vpc.project4_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project4_nat_gateway.id
  }

  tags = {
    Name = "project4_private_route_table"
  }
}

resource "aws_route_table_association" "project4_public_route_table_association_1" {
  subnet_id      = aws_subnet.project4_public_subnet_1.id
  route_table_id = aws_route_table.project4_public_route_table.id
}

resource "aws_route_table_association" "project4_public_route_table_association_2" {
  subnet_id      = aws_subnet.project4_public_subnet_2.id
  route_table_id = aws_route_table.project4_public_route_table.id
}

resource "aws_route_table_association" "project4_private_route_table_association_1" {
  subnet_id      = aws_subnet.project4_private_subnet_1.id
  route_table_id = aws_route_table.project4_private_route_table.id
}

resource "aws_route_table_association" "project4_private_route_table_association_2" {
  subnet_id      = aws_subnet.project4_private_subnet_2.id
  route_table_id = aws_route_table.project4_private_route_table.id
}