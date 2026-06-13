resource "aws_vpc" "project4_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "project4-vpc"
  }
}