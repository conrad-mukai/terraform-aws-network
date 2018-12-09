/*
 * network route table
 */

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "public-internet" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public" {
  count = "${local.az_count}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  count = "${local.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.name}-private${format("%02d", count.index+1)}"
  }
}

resource "aws_route" "private-nat" {
  count = "${local.az_count}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat-gw.*.id[count.index]}"
}

resource "aws_route_table_association" "private" {
  count = "${local.az_count}"
  subnet_id = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}
