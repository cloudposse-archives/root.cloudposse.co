terragrunt = {
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

  terraform {
    extra_arguments "crud" {
      commands = [
        "apply",
        "destroy",
        "plan",
      ]

      arguments = [
        "-lock-timeout=1m",
        "-no-color",
        "-input=false",
      ]

      env_vars = {
        TF_VAR_aws_assume_role_arn = "${get_env("TF_VAR_aws_assume_role_arn", "arn:aws:iam::323330167063:role/atlantis")}"
      }
    }
  }
}
