module "marc" {
  source  = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name    = "marc"
  pgp_key = "keybase:tamsky"
  groups  = "${local.admin_groups}"
  force_destroy = "true"
}

output "marc_decrypt_command" {
  value = "${module.marc.keybase_password_decrypt_command}"
}
