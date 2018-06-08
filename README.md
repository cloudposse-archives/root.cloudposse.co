# root.cloudposse.co

Terraform Infrastructure for Cloud Posse Parent ("Root") Organization in AWS.

__NOTE:__ You need to provision the Root Organization first before creating the Production, Staging, and Development infrastructure as it creates `dns` and `iam` resources needed for all sub accounts.


## Introduction

We use [geodesic](https://github.com/cloudposse/geodesic) to define and build world-class cloud infrastructures backed by AWS and powered by Kubernetes.

`geodesic` exposes many tools that can be used to define and provision AWS and Kubernetes resources.

Here is the list of tools we use to provision `cloudposse.co` infrastructure:

* [aws-vault](https://github.com/99designs/aws-vault)
* [chamber](https://github.com/segmentio/chamber)
* [terraform](https://www.terraform.io/)
* [kops](https://github.com/kubernetes/kops)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [helm](https://helm.sh/)
* [helmfile](https://github.com/roboll/helmfile)


## Quick Start

### Setup AWS Role

__NOTE:__ You need to only do this once.

Create IAM Access Key ID and Secret Access Key on AWS `root` account and setup MFA.

Configure AWS profile in `~/.aws/config`. Make sure to change `username@cloudposse.co` to your own IAM username.

```bash
[profile cpco-root-admin]
region=us-west-2
role_arn=arn:aws:iam::XXXXXXXXXx:role/cpco-root-admin
mfa_serial=arn:aws:iam::XXXXXXXXX:mfa/username@cloudposse.co
source_profile=cpco
```

### Install and setup aws-vault

__NOTE:__ You only need to do this once.

We use [aws-vault](https://github.com/99designs/aws-vault)
to store IAM credentials in your operating system's secure keystore and then generate temporary credentials from those to expose to your shell and applications.

Install [aws-vault](https://github.com/99designs/aws-vault/releases) on your local environment first.

On MacOS, you may use `homebrew cask`

```bash
brew cask install aws-vault
```

Then setup your secret credentials in `aws-vault` (input the IAM Access Key ID and Secret Access Key when prompted)

```bash
export AWS_VAULT_BACKEND=file
aws-vault add cpco
```

__NOTE:__ You should set `AWS_VAULT_BACKEND=file` in your shell rc config (e.g. `~/.bashrc`) so it persists.

For more info, see [aws-vault](https://docs.cloudposse.com/docs/aws-vault)


### Build Docker Image

```
# Initialize the project's build-harness
make init

# Build docker image
make docker/build
```


### Install the wrapper shell

```bash
make install
```


### Run the shell

```bash
root.cloudposse.co
```


__NOTE:__ Before provisioning AWS resources with Terraform, you need to create `tfstate-backend` (S3 bucket to store Terraform state and DynamoDB table for state locking).

Follow the steps in this [README](conf/tfstate-backend/README.md). You need to do it only once.


### Provision `iam` with Terraform

Change directory to `iam` folder
```bash
cd /conf/iam
```

Because we don't have any roles created yet, Terraform will not be able to assume roles.

We need to provision `iam` with `assume_role` block commented out to create all roles and policies.

Comment out `assume_role` block in `iam/main.tf`.

Run Terraform
```bash
init-terraform
terraform plan
terraform apply
```

Uncomment `assume_role` block in `iam/main.tf`.

`exit` out of container session and run `assume-role` to pick up the new role.

```bash
assume-role
```

For more info, see [geodesic-with-terraform](https://docs.cloudposse.com/v0.9.0/docs/geodesic-with-terraform)


### Provision `dns` with Terraform

Change directory to `dns` folder
```bash
cd /conf/dns
```

Run Terraform
```bash
init-terraform
terraform plan
terraform apply
```


### Provision `chamber` with Terraform

```bash
cd /conf/chamber
```

Run Terraform
```bash
init-terraform
terraform plan
terraform apply
```


### References

* https://docs.cloudposse.com
* https://github.com/segmentio/chamber
* https://aws.amazon.com/blogs/mt/the-right-way-to-store-secrets-using-parameter-store/
* https://github.com/kubernetes-incubator/external-dns/blob/master/docs/faq.md
* https://github.com/gravitational/workshop/blob/master/k8sprod.md
