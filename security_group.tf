/*
 * network security groups
 */

resource aws_security_group bastion {
  name_prefix = "${var.name}-bastion-"
  description = "allow ssh access to bastion"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = var.ssh_access
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  tags = {
    Name = "${var.name}-bastion"
  }
}

resource aws_security_group internal {
  name_prefix = "${var.name}-internal-"
  description = "allow access internal access"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-internal"
  }
}

resource aws_security_group_rule internal {
  type = "ingress"
  security_group_id = aws_security_group.internal.id
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = [var.vpc_cidr]
}

resource aws_security_group_rule outbound {
  type = "egress"
  security_group_id = aws_security_group.internal.id
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
}
