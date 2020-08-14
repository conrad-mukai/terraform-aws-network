/*
 * network test outputs
 */

output network {
  value = {
    vpc_id = module.network.vpc_id
    public_subnets = module.network.public_subnets
    private_subnets = module.network.private_subnets
    nat_ips = module.network.nat_ips
    public_route_table_id = module.network.public_route_table_id
    private_route_table_ids = module.network.private_route_table_ids
    internal_security_group_id = module.network.internal_security_group_id
    bastion_ips = module.network.bastion_ips
  }
}
