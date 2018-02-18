provider "aws" {
  region  = "${var.AWS_REGION}"
  profile = "${var.DEFAULT_PROFILE}"
}
