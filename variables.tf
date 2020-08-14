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
}


# security group settings

variable ssh_access {
  type = list(string)
  description = "list of CIDR blocks with ssh access"
  default = ["0.0.0.0/0"]
}


# bastion settings

variable bastion_ami {
  type = string
  description = "AMI for bastion"
}

variable bastion_user {
  type = string
  description = "default user for the bastion AMI"
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

variable private_key_path {
  type = string
  description = "local path to private key for for bootstrapping bastion"
}

variable authorized_keys_path {
  type = string
  description = "local path to the authorized_keys file"
}
