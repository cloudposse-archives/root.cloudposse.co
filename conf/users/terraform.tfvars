terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
  terraform {
    source = "git::https://github.com/cloudposse/terraform-root-modules.git//aws/users?ref=0.43.0"
    extra_arguments "smtp" {
      commands = ["plan", "apply", "destroy"]
      env_vars = {
        TF_VAR_smtp_username = "${get_env("SMTP_USERNAME", "")}"            
        TF_VAR_smtp_password = "${get_env("SMTP_PASSWORD", "")}" 
        TF_VAR_smtp_host = "${get_env("SMTP_HOST", "smtp.maigun.org")}"            
        TF_VAR_smtp_port = "${get_env("SMTP_PORT", "587")}"            
      }
    }
  }
}
