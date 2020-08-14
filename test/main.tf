/*
 * network test
 */

provider aws {
  region = var.region
}

data aws_availability_zones current {}

module network {
  source = "./.."
  name = var.name
  vpc_cidr = var.vpc_cidr
  availability_zones = data.aws_availability_zones.current.names
  ssh_access = var.ssh_access
  bastion_ami = var.bastion_ami
  bastion_user = var.bastion_user
  private_key_path = var.private_key_path
  authorized_keys_path = var.authorized_key_path
  key_name = var.key_name
}
