/*
 * network test
 *
 * To test the module do the following:
 *   1. create user_data/authorized keys from your public key;
 *   2. create terraform.tfvars from terraform.tfvars.example
 *   3. terraform get (one-time);
 *   4. terraform plan;
 *   5. terraform apply;
 *   6. test ssh to bastion; and
 *   7. terraform destroy (clean-up).
 */

provider "aws" {
  region = "${var.region}"
}

module "network" {
  source = ".."
  environment = "${var.environment}"
  app_name = "${var.app_name}"
  cidr_vpc = "172.16.0.0/16"
  availability_zones = "${var.availability_zones}"
  nat_eips = "${var.nat_eips}"
  allowed_ingress_list = "${var.allowed_ingress_list}"
  bastion_ami = "${var.bastion_ami}"
  bastion_user = "${var.bastion_user}"
  private_key_path = "${var.private_key_path}"
  authorized_keys = "${file(var.authorized_key_path)}"
  key_name = "${var.key_name}"
}
