/*
 * network templates
 */

data template_file setup-bastion {
  template = file("${path.module}/scripts/setup-bastion.sh")
  vars = {
    authorized_keys = local.authorized_keys
  }
}
