resource "aws_key_pair" "jenkins-ssh-key" {
  key_name   = "jenkins-ssh-key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
