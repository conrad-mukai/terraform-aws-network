/*
 * gateway configurations
 */

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-${var.app_name}-igw"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  count = "${aws_subnet.public-subnet.count}"
  allocation_id = "${var.nat_eips[count.index]}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route_table" "public-route-table" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-public-subnet-route-table-${format("%02d", count.index+1)}"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  count = "${aws_subnet.public-subnet.count}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public-route-table.*.id, count.index)}"
}

resource "aws_route_table" "private-route-table" {
  count = "${aws_nat_gateway.nat-gw.count}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat-gw.*.id, count.index)}"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-private-subnet-route-table-${format("%02d", count.index+1)}"
  }
}

resource "aws_route_table_association" "private-route-table-association" {
  count = "${aws_subnet.private-subnet.count}"
  subnet_id = "${element(aws_subnet.private-subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private-route-table.*.id, count.index)}"
}

resource "aws_route_table" "static-route-table" {
  count = "${aws_nat_gateway.nat-gw.count}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat-gw.*.id, count.index)}"
  }
  tags {
    Name = "${var.environment}-${var.app_name}-static-subnet-route-table-${format("%02d", count.index+1)}"
  }
}

resource "aws_route_table_association" "static-route-table-association" {
  count = "${aws_subnet.static-subnet.count}"
  subnet_id = "${element(aws_subnet.static-subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.static-route-table.*.id, count.index)}"
}
