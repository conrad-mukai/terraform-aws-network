# Network Module

## Description

This module creates the following:
1. VPC;
2. internet gateway;
3. subnets (public and 2 private);
4. NAT gateway (for each private subnet);
5. security groups; and
6. bastion hosts.

## Variables

| Name | Description | Default |
| ---- | ----------- | ------- |
| `allowed_egress_list` | list of CIDR blocks allowed out of VPC | ["0.0.0.0/0"] |
| `allowed_ingress_list` | list of CIDR blocks allowed into VPC | ["0.0.0.0/0"] |
| `app_name` | application name | infra |
| `availability_zones` | list of availability zones | |
| `authorized_keys` | public keys for SSH access into bastion | |
| `bastion_ami` | AMI for bastion | |
| `bastion_instance_type` | instance type for bastion instance | t2.micro |
| `bastion_user` | default user for the bastion AMI | |
| `cidr_vpc` | VPC /16 CIDR block | |
| `environment` | environment to configure | |
| `key_name` | key pair name to bootstrap bastion (will be replaced with authorized_keys) | |
| `nat_eips` | list of EIP IDs for the NAT gateways | |
| `private_key_path` | path to private key for for bootstrapping bastion | |

## Outputs

| Name | Description |
| ---- | ----------- |
| `bastion_ips` | list of public IP address for bastions |
| `internal_security_group_id` | security group ID for instances in the private subnet |
| `loopback_web_security_group_id` | security group ID that grants access from NAT gateways |
| `nat_ips` | list of IP addresses for NAT gateways |
| `private_subnet_ids` | list of private subnet IDs |
| `public_subnet_ids` | list of public subnet IDs |
| `static_subnet_ids` | list of subnet IDs for static IPs |
| `vpc_id` | VPC ID |
| `web_security_group_id` | security group ID for external web access |

## Tests
The test documentation can be found in test/main.tf.
