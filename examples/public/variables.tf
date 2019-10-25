# Provider
variable "region" {}
variable "profile" {}


# AWS Elasticsearch
variable "es_domain_name" {}
variable "es_version" {}


# Policies
variable "es_ips" {
  default = []
}

