# ALB CONFIGURATION
# =============================================================================
resource "aws_alb" "jenkins-elb" {
  name                       = "jenkins-elb"
  security_groups            = ["${aws_security_group.elb-securitygroup.id}"]
  internal                   = false
  enable_deletion_protection = false

  subnets = [
    "${aws_subnet.main-public-1.id}",
    "${aws_subnet.main-public-2.id}",
  ]
}

resource "aws_alb_target_group" "jenkins-elb-target" {
  name     = "jenkins-elb-target"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/login"
  }
}

resource "aws_alb_listener" "jenkins-elb-listener" {
#  depends_on        = ["aws_iam_server_certificate.jenkins-certificate"]
  load_balancer_arn = "${aws_alb.jenkins-elb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "arn:aws:acm:us-east-2:273083888550:certificate/4e3ce84a-6315-40c1-a31a-8cd181f7b355"

  default_action {
    target_group_arn = "${aws_alb_target_group.jenkins-elb-target.0.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "jenkins-elb-group-attach" {
  target_group_arn = "${aws_alb_target_group.jenkins-elb-target.arn}"
  target_id        = "${aws_instance.ec2-jenkins.id}"
  port             = 8080
}

# https://dev.classmethod.jp/cloud/aws/terraform-alb/

