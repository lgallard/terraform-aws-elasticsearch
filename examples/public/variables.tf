# Provider
variable "region" {}
variable "profile" {}


# AWS Elasticsearch
variable "es_domain_name" {}
variable "es_version" {}


# Whitelist (allow public IPs)
variable "whitelist" {
  default = []
}

