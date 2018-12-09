/*
 * network test variables
 */

variable "region" {
  type = "string"
}

variable "name" {
  default = "demo"
}

variable "ssh_access" {
  type = "list"
}

variable "web_access" {
  type = "list"
}

variable "domain" {
  default = "small.example.com"
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