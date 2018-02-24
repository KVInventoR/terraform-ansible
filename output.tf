output "jenkins-public_dns" {
  value = "${aws_instance.ec2-jenkins.*.public_dns}"
}

output "jenkins-private_ip" {
  value = "${aws_instance.ec2-jenkins.*.private_ip}"
}
