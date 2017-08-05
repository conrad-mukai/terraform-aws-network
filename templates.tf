/*
 * network templates
 */

data "template_file" "authorized-keys-setup" {
  template = "${file("${path.module}/scripts/authorized_keys-setup.sh")}"
  vars {
    user = "${var.bastion_user}"
    authorized_keys = "${var.authorized_keys}"
  }
}
