resource "aws_kms_key" "kms_key_ebs" {
  description = "KMS for EBS"
  deletion_window_in_days = 20
}
