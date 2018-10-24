terragrunt = {
  terraform {
    source = "git::git@github.com:cloudposse/terraform-root-modules.git//aws/users?ref=0.6.0"
    extra_arguments "smtp" {
      commands = [
        "apply",
        "plan",
      ]

      env_vars = {
        TF_VAR_smtp_username = "${get_env("SMTP_USERNAME", "")}"            
        TF_VAR_smtp_password = "${get_env("SMTP_PASSWORD", "")}" 
        TF_VAR_smtp_host = "${get_env("SMTP_HOST", "smtp.maigun.org")}"            
        TF_VAR_smtp_port = "${get_env("SMTP_PORT", "587")}"            
      }
    }
  }

  remote_state {
    backend = "s3"
    config {
      bucket         = "${get_env("TF_BUCKET", "")}"
      key            = "${path_relative_to_include()}/${get_env("TF_FILE", "terraform.tfstate")}"
      region         = "${get_env("TF_BUCKET_REGION", "us-east-1")}"
      encrypt        = true
      dynamodb_table = "${get_env("TF_DYNAMODB_TABLE", "")}"
    }
  }
}
