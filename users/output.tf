output "passwords" {
  value = "${zipmap(aws_iam_user_login_profile.passwords.*.user, aws_iam_user_login_profile.passwords.*.encrypted_password)}"
}
