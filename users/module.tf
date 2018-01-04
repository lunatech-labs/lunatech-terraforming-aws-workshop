provider "aws" {
  profile = "${var.aws_profile}"
  region = "eu-west-1"
}

resource "aws_iam_user" "users" {
  count = "${length(keys(var.emails_map))}"
  name = "${element(keys(var.emails_map), count.index)}"
  path = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "passwords" {
  count = "${length(aws_iam_user.users.*.name)}"
  user = "${element(aws_iam_user.users.*.name, count.index)}"
  pgp_key = "${var.emails_map[element(aws_iam_user.users.*.name, count.index)]}"
  password_reset_required = true
  password_length = 64
}

resource "aws_iam_group" "group" {
  name = "${var.group_name}"
}

resource "aws_iam_group_policy_attachment" "group_policy_system_administrator" {
  group = "${aws_iam_group.group.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

resource "aws_iam_group_policy_attachment" "group_policy_update_credentials" {
  group = "${aws_iam_group.group.name}"
  policy_arn = "${aws_iam_policy.policy_update_credentials.arn}"
}

resource "aws_iam_policy" "policy_update_credentials" {
  name = "IAMUpdateCredentials"
  policy = "${file("${path.module}/update-credentials.json")}"
}

resource "aws_iam_group_membership" "members" {
  group = "${aws_iam_group.group.name}"
  name = "${aws_iam_group.group.name}-membership"
  users = ["${aws_iam_user.users.*.name}"]
}

resource "aws_iam_access_key" "access_keys" {
  count = "${length(aws_iam_user.users.*.name)}"
  user = "${element(aws_iam_user.users.*.name, count.index)}"
  pgp_key = "${var.emails_map[element(aws_iam_user.users.*.name, count.index)]}"
}
