resource "aws_network_interface" "jenkins-eni" {
  subnet_id = "${aws_subnet.vpc-jenkins-public-1.id}"
  private_ips = ["10.0.1.7"]
  security_groups = ["${aws_security_group.securitygroup-ec2-jenkins.id}"]

  tags {
    Name = "jenkins-eni"
  }
}
