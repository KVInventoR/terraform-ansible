#output "name_servers" {
#  value = "${aws_route53_zone.default_hosted_zone.name_servers}"
#}

output "jenkins-private_ip" {
  value = "${aws_instance.ec2-jenkins.*.private_ip}"
}

output "jenkins-public_ip" {
  value = "${aws_instance.ec2-jenkins.*.public_ip}"
}

output "jenkins-public_dns" {
  value = "${aws_instance.ec2-jenkins.*.public_dns}"
}

output "elb" {
  value = "${aws_alb.jenkins-lb.dns_name}"
}

#output "route53-elb" {
#  value = "${aws_route53_record.jenkins-lb.name}"
#}
