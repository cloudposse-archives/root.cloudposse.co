module "josh" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name          = "josh"
  pgp_key       = "keybase:josh_myers"
  groups        = "${local.admin_groups}"
  force_destroy = "true"
}

output "josh_decrypt_command" {
  value = "${module.josh.keybase_password_decrypt_command}"
}
