module "demo" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name          = "demo"
  pgp_key       = "keybase:osterman"
  groups        = "${local.admin_groups}"
  force_destroy = "true"
}

output "demo_decrypt_command" {
  value = "${module.demon.keybase_password_decrypt_command}"
}
