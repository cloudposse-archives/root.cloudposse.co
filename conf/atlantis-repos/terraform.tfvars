terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git//?ref=tags/0.1.0"

    extra_arguments "github" {
      commands = ["plan", "apply", "destroy"]
      env_vars = {
        TF_VAR_github_token   = "${get_env("GITHUB_TOKEN", "")}"
        TF_VAR_webhook_secret = "${get_env("ATLANTIS_GH_WEBHOOK_SECRET", "")}"
      }
    }
  }
}

webhook_url = "https://atlantis.root.cloudposse.co/events"

webhook_active = true

github_organization = "cloudposse"

github_repositories = ["root.cloudposse.co"]

events = ["pull_request_review_comment", "pull_request", "pull_request_review", "issue_comment", "push"]

name = "web"
