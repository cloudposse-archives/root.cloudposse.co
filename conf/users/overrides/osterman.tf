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

module "osterman_welcome" {
  source   = "git::https://github.com/cloudposse/terraform-null-smtp-mail.git?ref=tags/0.1.0"
  enabled  = "false"
  host     = "${var.smtp_host}"
  port     = "${var.smtp_port}"
  username = "${var.smtp_username}"
  password = "${var.smtp_password}"
  from     = "ops@cloudposse.com"
  to       = ["erik@cloudposse.com"]
  subject  = "AWS User Account Created"
  body     = "${file("${path.module}/welcome.txt")}"

  vars = {
    signin_url               = "${local.signin_url}"
    username                 = "${module.osterman.user_name}"
    password_decrypt_command = "${module.osterman.keybase_password_decrypt_command}"
  }
}


