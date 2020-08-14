/*
 * network provisioners
 */

resource null_resource setup-bastion {
  count = local.az_count
  triggers = {
    bastion_id = aws_instance.bastion[count.index].id
    auth_keys = md5(local.authorized_keys)
  }
  connection {
    host = aws_eip.bastion[count.index].public_ip
    user = var.bastion_user
    private_key = local.private_key
  }
  provisioner file {
    content = data.template_file.setup-bastion.rendered
    destination = "/tmp/setup-bastion.sh"
  }
  provisioner remote-exec {
    inline = [
      "trap 'rm /tmp/setup-bastion.sh' EXIT",
      "chmod +x /tmp/setup-bastion.sh",
      "sudo /tmp/setup-bastion.sh"
    ]
  }
}
