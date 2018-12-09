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
1. security groups;
1. private Route53 zone; and
1. bastion hosts.

The following sub-sections describe these components in detail.

### VPC and Subnets

The module creates a public and private subnet in each availability zone. The
VPC CIDR is split into 2 halves. The public subnets are placed in the first
half and the private subnets in the second half. Each half is then divided by
a power of 2 large enough to house a subnet in each availability zone.

For example, starting with a VPC CIDR of 172.18.0.0/16, it splits into 2
address spaces 172.18.0.0-172.18.127.255 and 172.18.128.0-172.18.255.255.
Specifying 3 availability zones requires that each half is divided into 4 parts
since 4 is the lowest power of 2 that accommodates 3 availability zones. A
subnet is placed in the first 3 parts and the 4th is left unused. The actual
size of each subnet is determined by `public_cidr_prefix` and
`private_cidr_prefix` which are the number of bits in each subnet CIDR mask. If
-1 is specified the subnet occupies the entire address space.

Continuing with our example if `public_cidr_prefix` is set to 24 and
`private_cidr_prefix` is -1 then the result is:

| AZ1 | AZ2 | AZ3 | N/A |
| --- | --- | --- | --- |
| public subnet 1 (172.18.0.0/24)<br>172.18.0.0-172.18.0.255 | public subnet 2 (172.18.32.0/24)<br>172.18.32.0-172.18-32.255 | public subnet 3 (172.18.64.0/24)<br>172.18.64.0-172.64.255 | unused (172.18.96.0/24)<br>172.18.96.0-172.18.96.255 |
| unused<br>172.18.1.0-172.18.31.255 | unused<br>172.18.33.0-172.18.63.255 | unused<br>172.18.65.0-172.95.255 | unused<br>172.18.97.0-172.18.127.255 |
| private subnet 1 (172.18.128.0/19)<br>172.18.128.0-172.18.159.255 | private subnet 2 (172.18.160.0/19)<br>172.18.160.0-172.18.191.255 | private subnet 3 (172.18.192.0/19)<br>172.18.192.0-172.18.223.255 | unused (172.18.224.0/19)<br>172.18.224.0-172.18.255.255 |

### Gateways and Routing Tables

The module creates 1 internet gateway and a NAT gateway in each public subnet.
The routing table for the public subnets directs outbound traffic to the
internet gateway. The routing tables for each private subnet direct outbound
traffic to the NAT gateway in its availabilty zone which in turn directs
traffic to the internet gateway. The routing tables should be updated when a
VPC peering connection is established.

### Security Groups

The module creates 3 security groups:

| Security Group | Description |
| -------------- | ----------- |
| bastion | Defines SSH access to the public bastion servers. Access should only be granted to gateways used by admins. |
| internal | Defines access within the VPC. This group should be updated when a VPC peering connection is established. The security group also contains an egress rule for all protocols and all addresses. |
| web | Defines HTTP and HTTPS access to public endpoints. Development clouds should grant limited access (gateways used by employees and partners). Production should grant access to the Internet. |

### Route53 DNS Zone

The module creates a private Route53 DNS zone. Records for the bastion servers
are added.

### Bastions

To limit ssh access to specific users the only public servers with port 22 open
are the bastion servers. These servers are brought up with an AWS public key,
but that key is replaced with an authorized_key file containing a list of
users' personal public keys. Doing this improves security in 2 ways. First
access is only granted if an admin adds a user's key to the bastion. A single
key is more likely to be shared, so access becomes unmanaged. Revocation of a
shared key is also problematic. If ssh access is granted through a shared key
then revocation requires that a new key be generated and re-distributed to all
users except for the one whose access is being revoked. If every user had an
individual public key on a bastion then access is revoked by simply removing
that user's key.

A shared ssh key should be used for internal access. With this type of
configuration, the `~/.ssh/config` file can use the bastion as a proxy server.

For example suppose we define a VPC with the CIDR 172.16.0.0/16 and a bastion
host is created with a public IP address of 35.0.0.1. We want to use a personal
key file `my-key.pem` and a shared internal key of `shared-key.pem`. Finally,
assume all servers use Amazon Linux (which means the ssh user is `ec2-user`).
The following ssh config blocks would define proxy access:

    HostName bastion
        Host 35.0.0.1
        User ec2-user
        IdentityFile ~/.ssh/my-key.pem
    
    HostName 172.16.*
        User ec2-user
        IdentityFile ~/.ssh/shared-key.pem
        ProxyCommand ssh -q bastion -W %h:%p

With this set up you can ssh _directly_ to any internal server with a single
command. For example if a web server had a private IP of 172.16.0.6, then you
would simply enter:

    ssh 172.16.0.6

This transparently authenticates you at the bastion and then tunnel through to
the web server. There are many other tricks you can play with the bastion such
as creating tunnels for other tools such as command line SQL clients or web
browsers with the ssh -L option. Or do full on SOCKS proxy with the FoxyProxy
plugin and the ssh -D option.

## Input Variables

| Name | Description | Default |
| ---- | ----------- | ------- |
| `authorized_keys_path` | local path to the authorized_keys file | |
| `availability_zones` | list of availability zones | |
| `bastion_ami` | AMI for bastion | |
| `bastion_instance_type` | instance type for bastion | t2.micro |
| `bastion_user` | default user for the bastion AMI | |
| `dns_domain` | private top level DNS domain | |
| `dns_ttl` | TTL for DNS records | 300 |
| `key_name` | key pair name to bootstrap bastion | |
| `name` | name to use in tagging | |
| `private_cidr_prefix` | CIDR prefix (number of bits in mask) for private subnets (-1 indicates use the max subnet size) | -1 |
| `private_key_path` | local path to private key for for bootstrapping bastion | |
| `public_cidr_prefix` | CIDR prefix (number of bits in mask) for public subnets (-1 indicates use the max subnet size) | |
| `ssh_access` | list of CIDR blocks with ssh access | ["0.0.0.0/0"] |
| `vpc_cidr` | VPC CIDR block | |
| `web_access` | list of CIDR blocks with web access | ["0.0.0.0/0"] |

## Outputs

| Name | Description |
| ---- | ----------- |
| `bastion_ips` | list of public IP addresses for bastions |
| `internal_security_group_id` | security group ID for internal access |
| `nat_ips` | list of public IP addresses for NAT gateways |
| `private_route_table_ids` | list of private route table IDs |
| `private_subnet_ids` | list of private subnet IDs |
| `public_route_table_id` | public route table ID |
| `public_subnet_ids` | list of public subnet IDs |
| `route53_zone_id` | Route53 private zone ID |
| `vpc_id` | VPC ID |
| `web_security_group_id` | security group ID for external web access |

## Tests

See test/README.md.
