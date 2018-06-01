FROM r.cfcr.io/cloudposse/terraform-root-modules:0.1.5 as terraform-root-modules

FROM cloudposse/geodesic:0.9.17

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

# Terraform Vars
ENV TF_VAR_domain_name=root.cloudposse.co
ENV TF_VAR_namespace=cpco
ENV TF_VAR_stage=root

# chamber KMS config
ENV CHAMBER_KMS_KEY_ALIAS="alias/cpco-root-chamber"

# Copy root modules
COPY --from=terraform-root-modules /aws/tfstate-backend/ /conf/tfstate-backend/
COPY --from=terraform-root-modules /aws/chamber/ /conf/chamber/
COPY --from=terraform-root-modules /aws/cloudtrail/ /conf/cloudtrail/

# Place configuration in 'conf/' directory
COPY conf/ /conf/

# Filesystem entry for tfstate
RUN s3 fstab '${TF_BUCKET}' '/' '/secrets/tf'

WORKDIR /conf/
