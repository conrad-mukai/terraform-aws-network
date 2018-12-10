/*
 * network modules
 */

module "bastion-hostname" {
  source = "github.com/conrad-mukai/terraform-hostname.git"
  count = "${local.az_count}"
  fqdns = "${aws_route53_record.bastion.*.fqdn}"
  addresses = "${aws_instance.bastion.*.public_ip}"
  user = "${var.bastion_user}"
  private_key_path = "${var.private_key_path}"
}
