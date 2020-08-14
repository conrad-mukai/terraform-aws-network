/*
 * network outputs
 */

output vpc_id {
  description = "VPC ID"
  value = aws_vpc.vpc.id
}

output public_subnets {
  description = "list of public subnet IDs and addresses"
  value = [
    for i in range(local.az_count): {
      id = aws_subnet.public[i].id
      availability_zone = aws_subnet.public[i].availability_zone
      cidr_block = aws_subnet.public[i].cidr_block
    }
  ]
}

output private_subnets {
  description = "list of private subnet IDs and addresses"
  value = [
    for i in range(local.az_count): {
      id = aws_subnet.private[i].id
      availability_zone = aws_subnet.private[i].availability_zone
      cidr_block = aws_subnet.private[i].cidr_block
    }
  ]
}

output nat_ips {
  description = "list of public IP addresses for NAT gateways"
  value = aws_nat_gateway.nat-gw.*.public_ip
}

output public_route_table_id {
  description = "public route table ID"
  value = aws_route_table.public.id
}

output private_route_table_ids {
  description = "list of private route table IDs"
  value = aws_route_table.private.*.id
}

output internal_security_group_id {
  description = "security group ID for internal access"
  value = aws_security_group.internal.id
}

output bastion_ips {
  description = "list of public IP addresses for bastions"
  value = aws_eip.bastion.*.public_ip
}
