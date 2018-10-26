module "aknysh" {
  source  = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name    = "aknysh"
  pgp_key = "keybase:aknysh"
  groups  = "${local.admin_groups}"
  force_destroy = "true"
}

output "osterman_decrypt_command" {
  value = "${module.aknysh.keybase_password_decrypt_command}"
}
