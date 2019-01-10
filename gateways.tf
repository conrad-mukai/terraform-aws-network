/*
 * network gateways
 */

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  count = "${local.az_count}"
  allocation_id = "${var.nat_eip_ids[count.index]}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  depends_on = [
    "aws_internet_gateway.igw"
  ]
  tags {
    Name = "${var.name}"
  }
}
