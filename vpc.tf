/*
 * vpc configuration
 */

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.environment}-${var.app_name}-vpc"
  }
}
