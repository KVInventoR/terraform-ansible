resource "aws_route53_zone" "default_hosted_zone" {
  name   = "${var.DEFAULT_ROUTE53_ZONE}"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route53_record" "jenkins-elb" {
  zone_id = "${aws_route53_zone.default_hosted_zone.zone_id}"
  name    = "elb-jenkins.${var.DEFAULT_ROUTE53_ZONE}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.jenkins-elb.dns_name}"]
}
