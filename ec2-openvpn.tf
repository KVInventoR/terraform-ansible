resource "aws_instance" "ec2-openvpn" {
  count                  = 1
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.access-key.key_name}"
  subnet_id              = "${aws_subnet.main-public-1.id }"
  vpc_security_group_ids = ["${aws_security_group.ec2-securitygroup.id}"]
  source_dest_check  = false

  root_block_device {
    volume_size           = "${var.DEFAULT_EC2_SIZE}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get install tmux mc -y",
    ]
  }

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  tags {
    Name = "${format("openvpn-%03d", count.index + 1)}"
  }
}
