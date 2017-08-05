/*
 * network module outputs
 */

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.public-subnet.*.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.private-subnet.*.id}"
}

output "secondary_private_subnet_ids" {
  value = "${aws_subnet.secondary-private-subnet.*.id}"
}

output "web_security_group_id" {
  value = "${aws_security_group.web-security-group.id}"
}

output "internal_security_group_id" {
  value = "${aws_security_group.internal-security-group.id}"
}

output "loopback_web_security_group_id" {
  value = "${aws_security_group.loopback-web-security-group.id}"
}

output "bastion_ips" {
  value = "${join(",", aws_instance.bastion.*.public_ip)}"
}

output "nat_ips" {
  value = "${aws_nat_gateway.nat-gw.*.public_ip}"
}
