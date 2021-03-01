/*
 * network example variables
 */

variable region {
  type = string
  description = "AWS region"
}

variable name {
  type = string
  description = "name to tag resources"
  default = "demo"
}

variable vpc_cidr {
  type = string
  description = "CIDR for VPC"
  default = "172.16.0.0/16"
}

variable bastion_access {
  type = list(string)
  description = "list of CIDRs granted ssh access to bastions"
}

variable key_name {
  type = string
  description = "AWS key pair"
}

variable private_key {
  type = string
  description = "local path to the ssh private key from the AWS key pair"
}

variable authorized_key {
  type = string
  description = "local path to list of ssh public keys granting guest bastion access"
}
