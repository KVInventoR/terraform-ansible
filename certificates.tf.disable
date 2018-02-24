resource "aws_iam_server_certificate" "jenkins-certificate" {
  name = "jenkins-certificate"

  certificate_body = "${file(var.SSL_CERT_FOR_ELB)}"
  private_key      = "${file(var.SSL_KEY_FOR_ELB)}"
}
