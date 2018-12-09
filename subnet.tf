/*
 * network subnets
 */

resource "aws_subnet" "public" {
  count = "${local.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, local.public_cidr_prefix - local.vpc_cidr_prefix, local.public_subnet_increment * count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.name}-public${format("%02d", count.index+1)}"
  }
}

resource "aws_subnet" "private" {
  count = "${local.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, local.private_cidr_prefix - local.vpc_cidr_prefix, local.private_subnet_offset + (local.private_subnet_increment * count.index))}"
  tags {
    Name = "${var.name}-private${format("%02d", count.index+1)}"
  }
}
