FROM r.cfcr.io/cloudposse/terraform-root-modules:0.3.1 as terraform-root-modules

FROM cloudposse/geodesic:0.9.18

ENV DOCKER_IMAGE "cloudposse/root.cloudposse.co"
ENV DOCKER_TAG "latest"

ENV BANNER="root.cloudposse.co"

# Default AWS Profile name
ENV AWS_DEFAULT_PROFILE="cpco-root-admin"

# AWS Region
ENV AWS_REGION="us-west-2"

# Terraform State Bucket
ENV TF_BUCKET="cpco-root-terraform-state"
ENV TF_BUCKET_REGION="us-west-2"
ENV TF_DYNAMODB_TABLE="cpco-root-terraform-state-lock"

# Terraform vars
# https://www.terraform.io/docs/configuration/variables.html
ENV TF_VAR_region="us-west-2"
ENV TF_VAR_namespace="cpco"
ENV TF_VAR_stage="root"
ENV TF_VAR_parent_domain_name="cloudposse.co"
ENV TF_VAR_domain_name="root.cloudposse.co"
ENV TF_VAR_prod_account_email="info+prod@cloudposse.co"
ENV TF_VAR_staging_account_email="info+staging@cloudposse.co"
ENV TF_VAR_audit_account_email="info+audit@cloudposse.co"
ENV TF_VAR_dev_account_email="info+dev@cloudposse.co"
ENV TF_VAR_account_id=""
ENV TF_VAR_root_account_admin_user_names='["", ""]'
ENV TF_VAR_root_account_readonly_user_names='[]'
ENV TF_VAR_prod_account_id=""
ENV TF_VAR_prod_account_user_names='["", ""]'
ENV TF_VAR_staging_account_id=""
ENV TF_VAR_staging_account_user_names='["", ""]'
ENV TF_VAR_audit_account_id=""
ENV TF_VAR_audit_account_user_names='["", ""]'
ENV TF_VAR_dev_account_id=""
ENV TF_VAR_dev_account_user_names='["", ""]'
ENV TF_VAR_prod_name_servers='["", "", "", ""]'
ENV TF_VAR_staging_name_servers='["", "", "", ""]'
ENV TF_VAR_audit_name_servers='["", "", "", ""]'
ENV TF_VAR_dev_name_servers='["", "", "", ""]'
ENV TF_VAR_local_name_servers='["", "", "", ""]'


# chamber KMS config
ENV CHAMBER_KMS_KEY_ALIAS="alias/cpco-root-chamber"

# Copy root modules
COPY --from=terraform-root-modules /aws/accounts/ /conf/accounts/
COPY --from=terraform-root-modules /aws/acm/ /conf/acm/
COPY --from=terraform-root-modules /aws/chamber/ /conf/chamber/
COPY --from=terraform-root-modules /aws/cloudtrail/ /conf/cloudtrail/
COPY --from=terraform-root-modules /aws/iam/ /conf/iam/
COPY --from=terraform-root-modules /aws/organization/ /conf/organization/
COPY --from=terraform-root-modules /aws/root-dns/ /conf/root-dns/
COPY --from=terraform-root-modules /aws/tfstate-backend/ /conf/tfstate-backend/

# Filesystem entry for tfstate
RUN s3 fstab '${TF_BUCKET}' '/' '/secrets/tf'

WORKDIR /conf/
