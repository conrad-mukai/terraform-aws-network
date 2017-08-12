/*
 * bastion configuration
 */

resource "aws_instance" "bastion" {
  count = "${aws_subnet.public-subnet.count}"
  ami = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.bastion-security-group.id}",
                            "${aws_security_group.internal-security-group.id}"]
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  tags {
    Name = "${var.environment}-${var.app_name}-bastion-${format("%02d", count.index+1)}"
  }
}
