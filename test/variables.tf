/*
 * test variables
 */

variable "region" {
  type = "string"
}

variable "environment" {
  default = "sandbox"
}

variable "app_name" {
  default = "infra"
}

variable "availability_zones" {
  type = "list"
}

variable "cidr_vpc" {
  type = "string"
}

variable "allowed_ingress_list" {
  type = "list"
}

variable "key_name" {
  type = "string"
}

variable "private_key_path" {
  type = "string"
}

variable "authorized_key_path" {
  type = "string"
}

variable "bastion_ami" {
  type = "string"
}

variable "bastion_user" {
  type = "string"
}