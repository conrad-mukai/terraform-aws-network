# Network Module

Create and configure a network in AWS.

## Description

Given a VPC CIDR and a list of availability zones, this module creates the
following:
1. VPC;
1. internet gateway;
1. public and private subnets;
1. NAT gateways;
1. route tables;
1. security groups; and
1. bastion hosts.

The following sub-sections describe these components in detail.

### VPC and Subnets

The module creates a public and private subnet in each availability zone. The
subnets are sized using the VPC CIDR and the number of availability zones
specified:

| Number of Availability Zones | Public Subnet Size (Fraction of VPC) | Private Subnet Size (Fraction of VPC) |
| ---------------------------- | ------------------------------------ | ------------------------------------- |
| 1 | 1/4 | 1/2 |
| 2,3 | 1/16 | 1/4 |
| 4,5,6 | 1/64 | 1/8 |

### Gateways and Routing Tables

The module creates 1 internet gateway and a NAT gateway in each public subnet.
The routing table for the public subnets directs outbound traffic to the
internet gateway. The routing tables for each private subnet direct outbound
traffic to the NAT gateway in its availabilty zone which in turn directs
traffic to the internet gateway. The routing tables should be updated when a
VPC peering connection is established.

### Security Groups

The module creates 2 security groups:

| Security Group | Description |
| -------------- | ----------- |
| bastion | Defines SSH access to the public bastion servers. Access should only be granted to gateways used by admins. |
| internal | Defines access within the VPC. This group should be updated when a VPC peering connection is established. The security group also contains an egress rule for all protocols and all addresses. |

### Bastions

To limit ssh access to specific users the only public servers with port 22 open
are the bastion servers. These servers are brought up with an AWS key pair.
To restrict access this key should not be shared. Instead users who are granted
access must submit a public ssh key. This key will allow access to a `bastion`
user on the servers.

A shared ssh key should be used for internal access. With this type of
configuration, the `~/.ssh/config` file can use the bastion as a proxy server.

For example suppose we define a VPC with the CIDR 172.16.0.0/16 and a bastion
host is created with a public IP address of 35.0.0.1. We want to use a personal
key file `my-key.pem` and a shared internal key of `shared-key.pem`. Finally,
assume all servers use Amazon Linux (which means the ssh user is `ec2-user`).
The following ssh config blocks would define proxy access:

    HostName bastion
        Host 35.0.0.1
        User bastion
        IdentityFile ~/.ssh/my-key.pem
    
    HostName 172.16.*
        User ec2-user
        IdentityFile ~/.ssh/shared-key.pem
        ProxyCommand ssh -q bastion -W %h:%p

With this set up you can ssh _directly_ to any internal server with a single
command. For example if a web server had a private IP of 172.16.0.6, then you
would simply enter:

    ssh 172.16.0.6

This transparently authenticates you at the bastion and then tunnels through to
the web server. There are many other tricks you can play with the bastion such
as creating tunnels for other tools such as command line SQL clients or web
browsers with the ssh -L option. Or do full on SOCKS proxy with the FoxyProxy
plugin and the ssh -D option.

## Input Variables

| Name | Type | Description | Default |
| ---- | ---- | ----------- | ------- |
| authorized_keys_path | string | local path to the authorized_keys file |  |
| availability_zones | list(string) | list of availability zones |  |
| bastion_ami | string | AMI for bastion |  |
| bastion_instance_type | string | instance type for bastion | t3.micro |
| bastion_user | string | default user for the bastion AMI |  |
| key_name | string | key pair name to bootstrap bastion |  |
| name | string | name to use in tagging |  |
| private_key_path | string | local path to private key for for bootstrapping bastion |  |
| ssh_access | list(string) | list of CIDR blocks with ssh access | ["0.0.0.0/0"] |
| vpc_cidr | string | VPC CIDR block |  |

## Outputs

| Name | Description |
| ---- | ----------- |
| bastion_ips | list of public IP addresses for bastions |
| internal_security_group_id | security group ID for internal access |
| nat_ips | list of public IP addresses for NAT gateways |
| private_route_table_ids | list of private route table IDs |
| private_subnet_ids | list of private subnet IDs |
| public_route_table_id | public route table ID |
| public_subnet_ids | list of public subnet IDs and addresses |
| vpc_id | VPC ID |

## Tests

See test/README.md.
