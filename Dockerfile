FROM cloudposse/terraform-root-modules:0.11.0 as terraform-root-modules

FROM cloudposse/geodesic:0.124.2

ENV DOCKER_IMAGE="cloudposse/root.cloudposse.co"
ENV DOCKER_TAG="latest"

# General
ENV NAMESPACE="cpco"
ENV STAGE="root"

# Geodesic banner
ENV BANNER="root.cloudposse.co"

# Message of the Day
ENV MOTD_URL="https://geodesic.sh/motd"

# AWS Region
ENV AWS_REGION="us-west-2"
ENV AWS_DEFAULT_REGION="${AWS_REGION}"
ENV AWS_ACCOUNT_ID="323330167063"
ENV AWS_ROOT_ACCOUNT_ID="${AWS_ACCOUNT_ID}"

# Terraform state bucket and DynamoDB table for state locking
ENV TF_BUCKET_REGION="${AWS_REGION}"
ENV TF_BUCKET="${NAMESPACE}-${STAGE}-terraform-state"
ENV TF_DYNAMODB_TABLE="${NAMESPACE}-${STAGE}-terraform-state-lock"

# Default AWS Profile name
ENV AWS_DEFAULT_PROFILE="${NAMESPACE}-${STAGE}-admin"

# chamber KMS config
ENV CHAMBER_KMS_KEY_ALIAS="alias/${NAMESPACE}-${STAGE}-chamber"

# Copy root modules
COPY --from=terraform-root-modules /aws/tfstate-backend/ /conf/tfstate-backend/
COPY --from=terraform-root-modules /aws/root-dns/ /conf/root-dns/
COPY --from=terraform-root-modules /aws/organization/ /conf/organization/
COPY --from=terraform-root-modules /aws/accounts/ /conf/accounts/
COPY --from=terraform-root-modules /aws/account-settings/ /conf/account-settings/
COPY --from=terraform-root-modules /aws/root-iam/ /conf/root-iam/
COPY --from=terraform-root-modules /aws/iam/ /conf/iam/

# Place configuration in 'conf/' directory
COPY conf/ /conf/

# Install configuration dependencies
RUN make -C /conf install

# Filesystem entry for tfstate
RUN s3 fstab '${TF_BUCKET}' '/' '/secrets/tf'

# Install atlantis
RUN curl -fsSL -o /usr/bin/atlantis https://github.com/cloudposse/atlantis/releases/download/0.5.2/atlantis_linux_amd64 && \
    chmod 755 /usr/bin/atlantis

WORKDIR /conf/
