/*
 * network variables
 */


# general

variable "name" {
  type = "string"
  description = "name to use in tagging"
}


# subnet settings

variable "vpc_cidr" {
  type = "string"
  description = "VPC CIDR block"
}

variable "availability_zones" {
  type = "list"
  description = "list of availability zones"
}

variable "public_cidr_prefix" {
  type = "string"
  description = "CIDR prefix (number of bits in mask) for public subnets (-1 indicates use the max subnet size)"
}

variable "private_cidr_prefix" {
  description = "CIDR prefix (number of bits in mask) for private subnets (-1 indicates use the max subnet size)"
  default = -1
}


# security group settings

variable "ssh_access" {
  type = "list"
  description = "list of CIDR blocks with ssh access"
  default = ["0.0.0.0/0"]
}

variable "web_access" {
  type = "list"
  description = "list of CIDR blocks with web access"
  default = ["0.0.0.0/0"]
}


# route53 settings

variable "dns_domain" {
  type = "string"
  description = "private top level DNS domain (optional)"
}

variable "dns_ttl" {
  description = "TTL for DNS records"
  default = 300
}


# bastion settings

variable "bastion_ami" {
  type = "string"
  description = "AMI for bastion"
}

variable "bastion_user" {
  type = "string"
  description = "default user for the bastion AMI"
}

variable "bastion_instance_type" {
  description = "instance type for bastion"
  default = "t2.micro"
}

variable "key_name" {
  type = "string"
  description = "key pair name to bootstrap bastion"
}

variable "private_key_path" {
  type = "string"
  description = "local path to private key for for bootstrapping bastion"
}

variable "authorized_keys_path" {
  type = "string"
  description = "local path to the authorized_keys file"
}


# elastic ips

variable "nat_eip_ids" {
  type = "list"
  description = "list of elastic IP allocation IDs for NAT gateways"
}

variable "bastion_eip_ids" {
  type = "list"
  description = "list of elastic IP allocation IDs for bastions"
}
