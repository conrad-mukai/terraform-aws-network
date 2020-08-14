/*
 * network route53 resources
 */

resource aws_route53_zone dns {
  count = local.enable_dns ? 1 : 0
  name = var.dns_domain
  vpc {
    vpc_id = aws_vpc.vpc.id
  }
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource aws_route53_record bastion {
  count = local.enable_dns ? local.az_count : 0
  zone_id = aws_route53_zone.dns[0].zone_id
  name = aws_instance.bastion[count.index].tags["Name"]
  type = "A"
  ttl = var.dns_ttl
  records = [
    aws_instance.bastion[count.index].private_ip
  ]
}
