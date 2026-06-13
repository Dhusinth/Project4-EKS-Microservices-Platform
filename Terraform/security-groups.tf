resource "aws_security_group" "project4_alb_sg" {
  name        = "project4-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.project4_vpc.id

  tags = {
    Name = "project4_alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "project4_alb_sg_ingress_rule_1" {
  security_group_id = aws_security_group.project4_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "project4_alb_sg_ingress_rule_2" {
  security_group_id = aws_security_group.project4_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "project4_alb_sg_egress_rule" {
  security_group_id = aws_security_group.project4_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "project4_node_sg" {
  name        = "project4-node-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.project4_vpc.id


  tags = {
    Name = "project4_node_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "project4_node_sg_ingress_rule" {
  security_group_id            = aws_security_group.project4_node_sg.id
  referenced_security_group_id = aws_security_group.project4_alb_sg.id
  from_port                    = 30000
  ip_protocol                  = "tcp"
  to_port                      = 32767
}

resource "aws_vpc_security_group_egress_rule" "project4_node_sg_egress_rule" {
  security_group_id = aws_security_group.project4_node_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}