# terraform-aws-elasticsearch module

```
module "aws_es" {

  source = "git::https://github.com/lgallard/terraform-aws-elasticsearch.git"

  domain_name           = "elasticsearch_public"
  elasticsearch_version = "7.1"

  cluster_config = {
    dedicated_master_enabled = "true"
    instance_count           = "3"
    instance_type            = "r5.large.elasticsearch"
    zone_awareness_enabled   = "true"
    availability_zone_count  = "3"
  }

  ebs_options = {
    ebs_enabled = "true"
    volume_size = "25"
  }

  encrypt_at_rest = {
    enabled = "true"
  }

  snapshot_options_ = {
    automated_snapshot_start_hour = "23"
  }

  log_publishing_options = {
    enabled = "true"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

```

Note: You can also define the ElasticSearch cluster using just the module variables:

```

module "aws_es" {

  source = "git::https://github.com/lgallard/terraform-aws-elasticsearch.git"

  domain_name           = "elasticsearch_public"
  elasticsearch_version = "7.1"

  cluster_config_dedicated_master_enabled = true
  cluster_config_instance_count           = "3"
  cluster_config_instance_type            = "r5.large.elasticsearch"
  cluster_config_zone_awareness_enabled   = "true"
  cluster_config_availability_zone_count  = "3"

  ebs_options_ebs_enabled = true
  ebs_options_volume_size = "25"

  encrypt_at_rest_enabled = true

  snapshot_options_automated_snapshot_start_hour = "23"

  log_publishing_options_enabled = true

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

```
