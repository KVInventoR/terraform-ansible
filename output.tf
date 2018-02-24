output "jenkins-private_ip" {
  value = "${aws_instance.ec2-jenkins.*.private_ip}"
}

output "jenkins-public_dns" {
  value = "${aws_instance.ec2-jenkins.*.public_dns}"
}

output "lb-dns_name" {
  value = "${aws_alb.jenkins-lb.dns_name}"
}

output "jenkins-dns_name" {
  value = "jenkins.${data.aws_route53_zone.selected.name}"
}
