module "demo" {
  source        = "git::https://github.com/cloudposse/terraform-aws-iam-user.git?ref=tags/0.1.1"
  name          = "demo"
  pgp_key       = "keybase:osterman"
  groups        = ["cpco-testing-admin"]
  force_destroy = "true"
}

output "demo_decrypt_command" {
  value = "${module.demo.keybase_password_decrypt_command}"
}
