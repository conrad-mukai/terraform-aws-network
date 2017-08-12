/*
 * network test
 *
 * To test the module do the following:
 *   1. create terraform.tfvars from terraform.tfvars.example
 *   2. terraform init (one-time);
 *   3. terraform plan;
 *   4. terraform apply;
 *   5. test ssh to bastion; and
 *   6. terraform destroy (clean-up).
 */

provider "aws" {
  region = "${var.region}"
}

resource "aws_eip" "public-ips" {
  count = "${length(var.availability_zones)}"
  vpc = true
}

module "network" {
  source = ".."
  environment = "${var.environment}"
  app_name = "${var.app_name}"
  cidr_vpc = "${var.cidr_vpc}"
  availability_zones = "${var.availability_zones}"
  nat_eips = "${aws_eip.public-ips.*.id}"
  allowed_ingress_list = "${var.allowed_ingress_list}"
  bastion_ami = "${var.bastion_ami}"
  bastion_user = "${var.bastion_user}"
  private_key_path = "${var.private_key_path}"
  authorized_keys = "${file(var.authorized_key_path)}"
  key_name = "${var.key_name}"
}
