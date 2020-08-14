/*
 * network test variables
 */

variable region {
  type = string
}

variable name {
  default = "demo"
}

variable vpc_cidr {
  default = "172.16.0.0/16"
}

variable ssh_access {
  type = list(string)
}

variable key_name {
  type = string
}

variable private_key_path {
  type = string
}

variable authorized_key_path {
  type = string
}

variable bastion_ami {
  type = string
}

variable bastion_user {
  type = string
}
