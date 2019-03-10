module "scaledemo" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name          = "scaledemo"
  pgp_key       = "keybase:osterman"
  groups        = "${local.admin_groups}"
  force_destroy = "true"
}

output "scaledemo_decrypt_command" {
  value = "${module.scaledemo.keybase_password_decrypt_command}"
}
