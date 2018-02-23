resource "aws_key_pair" "access-key" {
  key_name   = "access-key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
