# IAM CONFIGURATION
# =============================================================================
resource "aws_iam_group" "admins" {
  name = "admins"
}

resource "aws_iam_user" "fulladmin" {
  name = "fulladmin"
}

resource "aws_iam_group_membership" "admin-users" {
  name  = "admin-users"
  group = "${aws_iam_group.admins.name}"

  users = [
    "${aws_iam_user.fulladmin.name}",
  ]
}

resource "aws_iam_group_policy" "admin-users" {
  name   = "admin-users"
  group  = "${aws_iam_group.admins.id}"
  policy = "${file("iam_policy/restrict_policy.json")}"
}
