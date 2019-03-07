module "osterman" {
  source  = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name    = "osterman"
  pgp_key = "keybase:osterman"
  groups  = "${local.admin_groups}"
  force_destroy = "true"
}

output "osterman_decrypt_command" {
  value = "${module.osterman.keybase_password_decrypt_command}"
}
