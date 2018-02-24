output "jenkins-dns_name" {
  value = "https://jenkins.${data.aws_route53_zone.selected.name}"
}

output "jenkins-private_ip" {
  value = "${aws_instance.ec2-jenkins.*.private_ip}"
}
