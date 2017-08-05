/*
 * network variables
 */

variable "environment" {
  type = "string"
  description = "environment to configure"
}

variable "app_name" {
  description = "application name"
  default = "infra"
}

variable "cidr_vpc" {
  type = "string"
  description = "VPC /16 CIDR block"
}

variable "cidr_public" {
  type = "list"
  description = "network number of /24 CIDR for public subnet"
  default = [0, 32, 64, 96]
}

variable "cidr_private" {
  type = "list"
  description = "network number of /19 CIDR for private subnet"
  default = [4, 5, 6, 7]
}

variable "cidr_private_secondary" {
  type = "list"
  description = "network number of /24 CIDR for secondary private subnet (to reserve IPs)."
  default = [31, 63, 95, 127]
}

variable "availability_zones" {
  type = "list"
  description = "availability zone list"
}

variable "allowed_ingress_list" {
  type = "list"
  description = "list of CIDR blocks allowed into VPC"
  default = ["0.0.0.0/0"]
}

variable "allowed_egress_list" {
  type = "list"
  description = "list of CIDR blocks allowed out of VPC"
  default = ["0.0.0.0/0"]
}

variable "bastion_ami" {
  type = "string"
  description = "AMI for bastion"
}

variable "bastion_instance_type" {
  description = "instance type for bastion"
  default = "t2.micro"
}

variable "bastion_user" {
  type = "string"
  description = "default user for the bastion AMI"
}

variable "nat_eips" {
  type = "list"
  description = "list of EIP IDs for the NAT gateways"
}

variable "key_name" {
  type = "string"
  description = "key pair name to bootstrap bastion"
}

variable "private_key_path" {
  type = "string"
  description = "path to private key for for bootstrapping bastion"
}

variable "authorized_keys" {
  type = "string"
  description = "public keys for SSH access into bastion"
}
