/*
 * network local variables
 */

locals {
  az_count = length(var.availability_zones)
  private_subnet_new_bits = local.az_count == 1 ? 1 : local.az_count <= 3 ? 2 : 3
  public_subnet_new_bits = 2 * local.private_subnet_new_bits
  public_subnet_cidrs = [for i in range(local.az_count): cidrsubnet(var.vpc_cidr, local.public_subnet_new_bits, i)]
  private_subnet_cidrs = [for i in range(local.az_count): cidrsubnet(var.vpc_cidr, local.private_subnet_new_bits, i+1)]
  authorized_keys = file(var.authorized_keys_path)
  private_key = file(var.private_key_path)
}
