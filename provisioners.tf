/*
 * Provisioners for network.
 */

resource "null_resource" "setup-bastion" {
  count = "${aws_instance.bastion.count}"
  triggers {
    bastion_id = "${element(aws_instance.bastion.*.id, count.index)}"
  }
  connection {
    host = "${element(aws_instance.bastion.*.public_ip, count.index)}"
    user = "${var.bastion_user}"
    private_key = "${file(var.private_key_path)}"
  }
  provisioner "file" {
    content = "${data.template_file.authorized-keys-setup.rendered}"
    destination = "/tmp/authorized-keys-setup.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/authorized-keys-setup.sh",
      "/tmp/authorized-keys-setup.sh",
      "rm /tmp/authorized-keys-setup.sh"
    ]
  }
}
