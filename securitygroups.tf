# SECURITY GROUP CONFIGURATION FOR EC2
# =============================================================================
resource "aws_security_group" "ec2-securitygroup" {
  depends_on  = ["aws_vpc.main", "aws_security_group.elb-securitygroup"]
  vpc_id      = "${aws_vpc.main.id}"
  name        = "EC2-Jenkins"
  description = "Security group that allows ssh,http,https and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = "${var.SECURITY_GROUP_ACCESS}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = "${var.SECURITY_GROUP_ACCESS}"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "TCP"
    security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  }

  tags {
    Name = "EC2-Jenkins"
  }
}

# SECURITY GROUP CONFIGURATION FOR ELB
# =============================================================================
resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "ELB-Jenkins"
  description = "Security group that allows http and https egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ELB-Jenkins"
  }
}
