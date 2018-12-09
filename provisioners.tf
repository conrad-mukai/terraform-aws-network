/*
 * network provisioners
 */

resource "null_resource" "setup-bastion" {
  count = "${local.az_count}"
  triggers {
    bastion_id = "${element(aws_instance.bastion.*.id, count.index)}"
    auth_keys = "${md5(local.authorized_keys)}"
  }
  connection {
    host = "${element(aws_instance.bastion.*.public_ip, count.index)}"
    user = "${var.bastion_user}"
    private_key = "${local.private_key}"
  }
  provisioner "file" {
    content = "${local.authorized_keys}"
    destination = ".ssh/authorized_keys"
  }
}
