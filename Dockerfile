FROM cloudposse/terraform-root-modules:0.3.4 as terraform-root-modules

FROM cloudposse/geodesic:0.9.18

ENV DOCKER_IMAGE="cloudposse/root.cloudposse.co"
ENV DOCKER_TAG="latest"

# Geodesic banner
ENV BANNER="root.cloudposse.co"

# AWS Region
ENV AWS_REGION="us-west-2"
ENV AWS_DEFAULT_REGION="${AWS_REGION}"

# Terraform vars
ENV TF_VAR_region="${AWS_REGION}"
ENV TF_VAR_account_id="323330167063"
ENV TF_VAR_namespace="cpco"
ENV TF_VAR_stage="root"

ENV TF_VAR_parent_domain_name="cloudposse.co"

ENV TF_VAR_root_domain_name="root.cloudposse.co"
ENV TF_VAR_root_account_admin_user_names='["admin@cloudposse.co"]'
ENV TF_VAR_root_account_readonly_user_names='[]'

ENV TF_VAR_prod_account_email="info+prod@cloudposse.co"
ENV TF_VAR_prod_account_id=""
ENV TF_VAR_prod_account_user_names='["admin@cloudposse.co"]'
ENV TF_VAR_prod_name_servers='["", "", "", ""]'

ENV TF_VAR_staging_account_email="info+staging@cloudposse.co"
ENV TF_VAR_staging_account_id=""
ENV TF_VAR_staging_account_user_names='["admin@cloudposse.co"]'
ENV TF_VAR_staging_name_servers='["", "", "", ""]'

ENV TF_VAR_audit_account_email="info+audit@cloudposse.co"
ENV TF_VAR_audit_account_id=""
ENV TF_VAR_audit_account_user_names='["admin@cloudposse.co"]'
ENV TF_VAR_audit_name_servers='["", "", "", ""]'

ENV TF_VAR_dev_account_email="info+dev@cloudposse.co"
ENV TF_VAR_dev_account_id="838456590850"
ENV TF_VAR_dev_account_user_names='["admin@cloudposse.co"]'
ENV TF_VAR_dev_name_servers='["", "", "", ""]'

ENV TF_VAR_testing_account_email="info+testing@cloudposse.co"
ENV TF_VAR_testing_account_id="126450723953"
ENV TF_VAR_testing_account_user_names='["admin@cloudposse.co"]'
ENV TF_VAR_testing_name_servers='["ns-312.awsdns-39.com", "ns-1416.awsdns-49.org", "ns-619.awsdns-13.net", "ns-1794.awsdns-32.co.uk"]'

ENV TF_VAR_local_name_servers='["", "", "", ""]'

# Terraform state bucket and DynamoDB table for state locking
ENV TF_BUCKET_REGION="${AWS_REGION}"
ENV TF_BUCKET="${TF_VAR_namespace}-${TF_VAR_stage}-terraform-state"
ENV TF_DYNAMODB_TABLE="${TF_VAR_namespace}-${TF_VAR_stage}-terraform-state-lock"

# Default AWS Profile name
ENV AWS_DEFAULT_PROFILE="${TF_VAR_namespace}-${TF_VAR_stage}-admin"

# Copy root modules
COPY --from=terraform-root-modules /aws/tfstate-backend/ /conf/tfstate-backend/
COPY --from=terraform-root-modules /aws/root-dns/ /conf/root-dns/
COPY --from=terraform-root-modules /aws/organization/ /conf/organization/
COPY --from=terraform-root-modules /aws/accounts/ /conf/accounts/
COPY --from=terraform-root-modules /aws/iam/ /conf/iam/
COPY --from=terraform-root-modules /aws/cloudtrail/ /conf/cloudtrail/

# Filesystem entry for tfstate
RUN s3 fstab '${TF_BUCKET}' '/' '/secrets/tf'

WORKDIR /conf/
