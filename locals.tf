/*
 * network local variables
 */

locals {
  vpc_cidr_elements = ["${split("/", var.vpc_cidr)}"]
  vpc_cidr_prefix = "${local.vpc_cidr_elements[1]}"
  az_count = "${length(var.availability_zones)}"
  min_prefix = "${(local.az_count == 1 ? 1 : local.az_count == 2 ? 2 : local.az_count <= 4 ? 3 : local.az_count <= 8 ? 4 : 5)+local.vpc_cidr_prefix}"
  public_cidr_prefix = "${var.public_cidr_prefix == -1 ? local.min_prefix : var.public_cidr_prefix}"
  private_cidr_prefix = "${var.private_cidr_prefix == -1 ? local.min_prefix : var.private_cidr_prefix}"
  public_subnet_increment = "${pow(2, local.public_cidr_prefix - local.min_prefix)}"
  private_subnet_increment = "${pow(2, local.private_cidr_prefix - local.min_prefix)}"
  private_subnet_offset = "${pow(2, local.private_cidr_prefix - local.vpc_cidr_prefix - 1)}"
  private_key = "${file(var.private_key_path)}"
  authorized_keys = "${file(var.authorized_keys_path)}"
}

data "aws_eip" "bastion" {
  count = "${local.az_count}"
  id = "${var.bastion_eip_ids[count.index]}"
}
