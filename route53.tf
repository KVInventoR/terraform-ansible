data "aws_route53_zone" "selected" {
  name = "${var.ROUTE53_ZONE}"
  private_zone = false
}

resource "aws_route53_record" "jenkins-url" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "jenkins.${data.aws_route53_zone.selected.name}"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_alb.jenkins-lb.dns_name}"]
}
