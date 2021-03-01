# ----------------------------------------------------------------------------
# CREATE A VPC WITH PUBLIC/PRIVATE SUBNETS
# This module creates a VPC with public and private subnets across specified
# availability zones. The module also creates gateways, routing tables,
# security groups, bastion servers, and an optional private Route53 zone.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 0.13.0"
}

# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------

resource aws_vpc this {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

# -----------------------------------------------------------------------------
# Subnets
# Sub-divide the VPC address space into blocks for the public and private
# subnets. The number of availability zones is used to determine CIDR mask
# size for public and private subnets (with private subnets getting a smaller
# mask and subsequent larger address space).
# -----------------------------------------------------------------------------

locals {
  az_count = length(var.availability_zones)
  private_subnet_new_bits = floor(log(local.az_count, 2)) + 1
  public_subnet_new_bits = 2 * local.private_subnet_new_bits
  public_subnet_cidrs = [for i in range(local.az_count): cidrsubnet(var.vpc_cidr, local.public_subnet_new_bits, i)]
  private_subnet_cidrs = [for i in range(local.az_count): cidrsubnet(var.vpc_cidr, local.private_subnet_new_bits, i+1)]
}

data aws_availability_zone this {
  count = local.az_count
  name = var.availability_zones[count.index]
}

resource aws_subnet public {
  count = local.az_count
  vpc_id = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]
  cidr_block = local.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-${data.aws_availability_zone.this[count.index].zone_id}"
  }
}

resource aws_subnet private {
  count = local.az_count
  vpc_id = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]
  cidr_block = local.private_subnet_cidrs[count.index]
  tags = {
    Name = "${var.name}-private-${data.aws_availability_zone.this[count.index].zone_id}"
  }
}

# -----------------------------------------------------------------------------
# Gateways
#
# Create an Internet gateway and one or more NAT gateways. Multiple NAT
# gateways can be allocated to reduce intra-region data transfer costs.
# The break-even point for additional NAT gateways is around 1.6 TB/month of
# traffic from private subnets to the Internet.
#
# The elastic IPs for NAT gateways are created but cannot be destroyed through
# Terraform. This is to prevent accidental deletion of the elastic IPs. Since
# the elastic IPs may be shared with external organizations, their loss would
# be extremely detrimental. To delete the elastic IPs remove them from the
# Terraform state. They can then be deleted manually.
# -----------------------------------------------------------------------------

resource aws_internet_gateway this {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = var.name
  }
}

resource aws_eip nat_gateways {
  count = var.nat_gateway_count
  vpc = true
  depends_on = [
    aws_internet_gateway.this
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource aws_nat_gateway this {
  count = var.nat_gateway_count
  allocation_id = aws_eip.nat_gateways[count.index].id
  subnet_id = element(aws_subnet.public[*].id, count.index)
  depends_on = [
    aws_internet_gateway.this
  ]
  tags = {
    Name = "${var.name}-${count.index+1}"
  }
}

# -----------------------------------------------------------------------------
# Route Tables
# Route tables for the subnets via the gateways are defined here.
# -----------------------------------------------------------------------------

resource aws_route_table public {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-public"
  }
}

resource aws_route public-internet {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}

resource aws_route_table_association public {
  count = local.az_count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource aws_route_table private {
  count = var.nat_gateway_count
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-private-${count.index+1}"
  }
}

resource aws_route private-nat {
  count = var.nat_gateway_count
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this[count.index].id
}

resource aws_route_table_association private {
  count = local.az_count
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# -----------------------------------------------------------------------------
# Security Groups
# Create 2 security groups. One permitting all internal traffic within the VPC.
# The other is to allow ssh access to bastion servers. The bastion_access
# variable specifies addresses that are allowed to access the bastion servers.
# -----------------------------------------------------------------------------

resource aws_security_group bastion {
  name = "${var.name}-bastion"
  description = "allow ssh access to bastion"
  vpc_id = aws_vpc.this.id
  ingress {
    cidr_blocks = var.bastion_access
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  tags = {
    Name = "${var.name}-bastion"
  }
}

resource aws_security_group internal {
  name = "${var.name}-internal"
  description = "allow internal access"
  vpc_id = aws_vpc.this.id
  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  tags = {
    Name = "${var.name}-internal"
  }
}

# -----------------------------------------------------------------------------
# Bastions
# Create one or more bastion servers. Bastion servers allow ssh access to the
# VPC from a list of IP addresses. This should be used for administrative
# purposes. Access to the server is granted through ssh keys. A list of public
# ssh keys are placed in the account of the guest user on all the servers.
# -----------------------------------------------------------------------------

data aws_ami bastion {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-minimal-hvm-*"]
  }
}

resource random_shuffle bastion_subnets {
  input = aws_subnet.public[*].id
}

resource aws_instance bastion {
  count = var.bastion_count
  ami = data.aws_ami.bastion.image_id
  instance_type = var.bastion_instance_type
  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]
  subnet_id = element(random_shuffle.bastion_subnets.result, count.index)
  key_name = var.key_name
  associate_public_ip_address = true
  user_data = file("${path.module}/scripts/user_data")
  tags = {
    Name = "${var.name}-bastion-${count.index+1}"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}

resource null_resource bastion {
  count = var.bastion_count
  triggers = {
    bastion_id = aws_instance.bastion[count.index].id
    auth_keys = filemd5(var.authorized_keys)
  }
  connection {
    host = aws_instance.bastion[count.index].public_ip
    user = "ec2-user"
    private_key = file(var.private_key)
  }
  provisioner file {
    source = var.authorized_keys
    destination = "/tmp/authorized_keys"
  }
  provisioner file {
    source = "${path.module}/scripts/setup-ssh.sh"
    destination = "/tmp/setup-ssh.sh"
  }
  provisioner remote-exec {
    inline = [
      "chmod +x /tmp/setup-ssh.sh",
      "sudo /tmp/setup-ssh.sh",
      "rm /tmp/setup-ssh.sh"
    ]
  }
}
