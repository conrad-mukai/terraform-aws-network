/*
 * security group configuration
 */

resource "aws_security_group" "bastion-security-group" {
  name_prefix = "${var.environment}-${var.app_name}-bastion-"
  description = "allow ssh access to bastion"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    cidr_blocks = "${var.allowed_ingress_list}"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = "${concat(var.allowed_egress_list, list(var.cidr_vpc))}"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-bastion-sg"
  }
}

resource "aws_security_group" "web-security-group" {
  name_prefix = "${var.environment}-${var.app_name}-web-"
  description = "allows http/https access"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    cidr_blocks = "${var.allowed_ingress_list}"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = "${var.allowed_ingress_list}"
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  "egress" {
    cidr_blocks = "${concat(var.allowed_egress_list, list(var.cidr_vpc))}"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-web-sg"
  }
}

resource "aws_security_group" "internal-security-group" {
  name_prefix = "${var.environment}-${var.app_name}-internal-"
  description = "allow access from within VPC"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    cidr_blocks = ["${var.cidr_vpc}"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress {
    cidr_blocks = "${concat(var.allowed_egress_list, list(var.cidr_vpc))}"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-internal-sg"
  }
}

resource "aws_security_group" "loopback-web-security-group" {
  name_prefix = "${var.environment}-${var.app_name}-loopback-web-"
  description = "allows http/https access from internal sources"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    cidr_blocks = ["${formatlist("%s/32", aws_nat_gateway.nat-gw.*.public_ip)}"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = ["${formatlist("%s/32", aws_nat_gateway.nat-gw.*.public_ip)}"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-loopback-web-sg"
  }
}