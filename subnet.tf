/*
 * subnet configurations
 */

resource "aws_subnet" "public-subnet" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block = "${cidrsubnet(var.cidr_vpc, 8, var.cidr_public[count.index])}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.environment}-${var.app_name}-public-subnet-${format("%02d", count.index+1)}"
  }
}

resource "aws_subnet" "private-subnet" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block = "${cidrsubnet(var.cidr_vpc, 3, var.cidr_private[count.index])}"
  tags {
    Name = "${var.environment}-${var.app_name}-private-subnet-${format("%02d", count.index+1)}"
  }
}

resource "aws_subnet" "static-subnet" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block = "${cidrsubnet(var.cidr_vpc, 8, var.cidr_static[count.index])}"
  tags {
    Name = "${var.environment}-${var.app_name}-static-subnet-${format("%02d", count.index+1)}"
  }
}
