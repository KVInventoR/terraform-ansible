resource "aws_security_group" "securitygroup-ec2-jenkins" {
  depends_on = ["aws_vpc.vpc-jenkins", "aws_security_group.securitygroup-lb-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  name = "securitygroup-ec2-jenkins"
  description = "Security group that allows ingress and all egress traffic to EC2"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = "${var.SECURITY_GROUP_ACCESS}"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    security_groups = ["${aws_security_group.securitygroup-lb-jenkins.id}"]
  }

  tags {
    Name = "securitygroup-ec2-jenkins"
  }
}

resource "aws_security_group" "securitygroup-lb-jenkins" {
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  name = "securitygroup-lb-jenkins"
  description = "Security group that allows ingress and all egress traffic to LB"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "securitygroup-lb-jenkins"
  }
}
