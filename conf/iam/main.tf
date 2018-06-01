terraform {
  required_version = ">= 0.11.2"

  backend "s3" {}
}

module "identity" {
  source = "git::git@github.com:cloudposse/terraform-aws-account-metadata.git?ref=add-account-ids"
}

variable "aws_assume_role_arn" {}

provider "aws" {
  assume_role {
    role_arn = "${var.aws_assume_role_arn}"
  }
}

# Provision group access to root account with MFA
module "organization_access_group_root" {
  source           = "git::https://github.com/cloudposse/terraform-aws-iam-assumed-roles.git?ref=tags/0.2.0"
  namespace        = "${module.identity.namespace}"
  stage            = "root"
  admin_name       = "admin"
  readonly_name    = "readonly"
  admin_user_names = ["erik@cloudposse.com", "igor@cloudposse.com", "andriy@cloudposse.com", "sarkis@cloudposse.com"]
}

# Provision group access to production account
module "organization_access_group_prod" {
  source            = "git::https://github.com/cloudposse/terraform-aws-organization-access-group.git?ref=tags/0.1.2"
  namespace         = "${module.identity.namespace}"
  stage             = "prod"
  name              = "admin"
  user_names        = ["erik@cloudposse.com", "igor@cloudposse.com", "andriy@cloudposse.com", "sarkis@cloudposse.com"]
  member_account_id = "${module.identity.accounts["prod"]}"
}

# Provision group access to staging account
module "organization_access_group_staging" {
  source            = "git::https://github.com/cloudposse/terraform-aws-organization-access-group.git?ref=tags/0.1.2"
  namespace         = "${module.identity.namespace}"
  stage             = "staging"
  name              = "admin"
  user_names        = ["erik@cloudposse.com", "igor@cloudposse.com", "andriy@cloudposse.com", "sarkis@cloudposse.com"]
  member_account_id = "${module.identity.accounts["staging"]}"
}

# Provision group access to dev account
module "organization_access_group_dev" {
  source            = "git::https://github.com/cloudposse/terraform-aws-organization-access-group.git?ref=tags/0.1.2"
  namespace         = "${module.identity.namespace}"
  stage             = "dev"
  name              = "admin"
  user_names        = ["erik@cloudposse.com", "igor@cloudposse.com", "andriy@cloudposse.com", "sarkis@cloudposse.com"]
  member_account_id = "${module.identity.accounts["dev"]}"
}
