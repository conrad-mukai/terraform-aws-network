/*
 * network outputs
 */

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "nat_ips" {
  value = "${aws_nat_gateway.nat-gw.*.public_ip}"
}

output "public_route_table_id" {
  value = "${aws_route_table.public.id}"
}

output "private_route_table_ids" {
  value = "${aws_route_table.private.*.id}"
}

output "web_security_group_id" {
  value = "${aws_security_group.web.id}"
}

output "internal_security_group_id" {
  value = "${aws_security_group.internal.id}"
}

output "route53_zone_id" {
  value = "${aws_route53_zone.dns.zone_id}"
}

output "bastion_ips" {
  value = "${aws_instance.bastion.*.public_ip}"
}
