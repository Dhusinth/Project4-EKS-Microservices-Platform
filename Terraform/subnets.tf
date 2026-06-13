resource "aws_subnet" "project4_public_subnet_1" {
  vpc_id                  = aws_vpc.project4_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name                     = "project4-public-subnet-1"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "project4_public_subnet_2" {
  vpc_id                  = aws_vpc.project4_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"


  tags = {
    Name                     = "project4-public-subnet-2"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "project4_private_subnet_1" {
  vpc_id            = aws_vpc.project4_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name                              = "project4-private-subnet-1"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "project4_private_subnet_2" {
  vpc_id            = aws_vpc.project4_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name                              = "project4-private-subnet-2"
    "kubernetes.io/role/internal-elb" = 1
  }
}