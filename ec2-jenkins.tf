resource "aws_instance" "ec2-jenkins" {
  # count                  = 1
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.access-key.key_name}"

  network_interface {
    network_interface_id = "${aws_network_interface.jenkins-eni.id}"
    device_index = 0
  }

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
    # Name = "jenkins"
    Name = "${format("jenkins-%03d", count.index + 1)}"
  }
}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "${var.AWS_REGION}a"
  size              = "${var.EBS_VOLUME_SIZE}"
  type              = "gp2"

  tags {
    Name = "extra volume data"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name  = "${var.INSTANCE_DEVICE_NAME}"
  volume_id    = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id  = "${aws_instance.ec2-jenkins.id}"
  skip_destroy = true
}
