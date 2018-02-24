resource "aws_network_interface" "jenkins-eni" {
  subnet_id       = "${aws_subnet.main-public-1.id}"
  private_ips     = ["10.0.1.7"]
  security_groups = ["${aws_security_group.ec2-securitygroup.id}"]

  tags {
    Name = "jenkins-eni"
  }
}
