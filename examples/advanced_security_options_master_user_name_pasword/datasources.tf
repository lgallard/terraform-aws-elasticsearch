# Use this data source to get the access to the effective Account ID in which
# Terraform is working.
data "aws_caller_identity" "current" {}

# To obtain the name of the AWS region configured on the provider
data "aws_region" "current" {}


