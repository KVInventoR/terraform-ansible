resource "aws_alb" "jenkins-lb" {
  name = "jenkins-lb"
  security_groups = ["${aws_security_group.securitygroup-lb-jenkins.id}"]
  internal = false
  enable_deletion_protection = false

  subnets = [
    "${aws_subnet.vpc-jenkins-public-1.id}",
    "${aws_subnet.vpc-jenkins-public-2.id}",
  ]
}

resource "aws_alb_target_group" "jenkins-lb-target" {
  name = "jenkins-lb-target"
  port = 8080
  protocol = "HTTP"
  vpc_id = "${aws_vpc.vpc-jenkins.id}"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
    path = "/login"
  }
}

resource "aws_alb_listener" "jenkins-lb-listener" {
  load_balancer_arn = "${aws_alb.jenkins-lb.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2015-05"
  certificate_arn = "${var.SSL_CERT_FOR_ELB}"
  default_action {
    target_group_arn = "${aws_alb_target_group.jenkins-lb-target.0.arn}"
    type = "forward"
  }
}

resource "aws_alb_target_group_attachment" "jenkins-lb-group-attach" {
  target_group_arn = "${aws_alb_target_group.jenkins-lb-target.arn}"
  target_id = "${aws_instance.ec2-jenkins.id}"
  port = 8080
}
