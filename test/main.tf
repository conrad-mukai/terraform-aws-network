/*
 * network test
 */

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "current" {}

locals {
  az_list = "${slice(data.aws_availability_zones.current.names, 0, ceil(1.0*length(data.aws_availability_zones.current.names)/2))}"
  az_count = "${length(local.az_list)}"
}


resource "aws_eip" "nat_eips" {
  count = "${local.az_count}"
  vpc = true
}

resource "aws_eip" "bastion_eips" {
  count = "${local.az_count}"
  vpc = true
}

module "network" {
  source = ".."
  name = "${var.name}"
  vpc_cidr = "172.16.0.0/20"
  public_cidr_prefix = 28
  private_cidr_prefix = 24
  availability_zones = "${local.az_list}"
  ssh_access = "${var.ssh_access}"
  web_access = "${var.web_access}"
  dns_domain = "${var.domain}"
  bastion_ami = "${var.bastion_ami}"
  bastion_user = "${var.bastion_user}"
  private_key_path = "${var.private_key_path}"
  authorized_keys_path = "${var.authorized_key_path}"
  key_name = "${var.key_name}"
  nat_eip_ids = "${aws_eip.nat_eips.*.id}"
  bastion_eip_ids = "${aws_eip.bastion_eips.*.id}"
}
