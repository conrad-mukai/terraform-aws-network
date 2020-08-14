/*
 * network eip resources
 */

resource aws_eip nat {
  count = local.az_count
  vpc = true
}

resource aws_eip bastion {
  count = local.az_count
  vpc = true
}
