/*
 * network variables
 */


# general

variable name {
  type = string
  description = "name to use in tagging"
}


# network settings

variable vpc_cidr {
  type = string
  description = "VPC CIDR block"
}

variable availability_zones {
  type = list(string)
  description = "list of availability zones"
  validation {
    condition = length(var.availability_zones) == length(toset(var.availability_zones))
    error_message = "Duplicate availability zones."
  }
}


# gateway settings

variable nat_gateway_count {
  type = number
  description = "number of NAT gateways to create"
  default = 1
  validation {
    condition = var.nat_gateway_count >= 1
    error_message = "Minimum number of NAT gateways is 1."
  }
}


# security group settings

variable bastion_access {
  type = list(string)
  description = "list of CIDR blocks with bastion access"
}


# bastion settings

variable bastion_count {
  type = number
  description = "number of bastion servers"
  default = 1
  validation {
    condition = var.bastion_count >= 1
    error_message = "Minimum number of bastion servers is 1."
  }
}

variable bastion_instance_type {
  type = string
  description = "instance type for bastion"
  default = "t3.micro"
}

variable key_name {
  type = string
  description = "key pair name to bootstrap bastion"
}

variable private_key {
  type = string
  description = "local path to private key for for bootstrapping bastion"
}

variable authorized_keys {
  type = string
  description = "local path to the authorized_keys file"
}
