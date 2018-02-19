output "name_servers" {
  value = "${aws_route53_zone.default_hosted_zone.name_servers}"
}

output "certificate" {
  value = "${aws_iam_server_certificate.jenkins-certificate.arn}"
}

output "private_ip" {
  value = "${aws_instance.ec2-jenkins.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.ec2-jenkins.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.ec2-jenkins.public_dns}"
}

output "elb" {
  value = "${aws_alb.jenkins-elb.dns_name}"
}

output "route53-elb" {
  value = "${aws_route53_record.jenkins-elb.name}"
}
