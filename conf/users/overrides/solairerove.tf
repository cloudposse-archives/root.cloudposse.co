module "solairerove" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name          = "solairerove"
  pgp_key       = "keybase:solairerove"
  groups        = "${local.admin_groups}"
  force_destroy = "true"
}

output "solairerove_decrypt_command" {
  value = "${module.solairerove.keybase_password_decrypt_command}"
}
