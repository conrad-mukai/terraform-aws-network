/*
 * bastion
 */

resource "aws_instance" "bastion" {
  count = "${local.az_count}"
  ami = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
    "${aws_security_group.internal.id}"
  ]
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  tags {
    Name = "${var.name}-bastion${format("%02d", count.index+1)}"
  }
}

resource "aws_eip_association" "bastion" {
  count = "${local.az_count}"
  allocation_id = "${var.bastion_eip_ids[count.index]}"
  instance_id = "${aws_instance.bastion.*.id[count.index]}"
}
