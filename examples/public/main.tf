module "aws_es" {

  source = "lgallard/elasticsearch/aws"

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

  node_to_node_encryption = {
    enabled = "true"
  }

  snapshot_options = {
    automated_snapshot_start_hour = "23"
  }

  log_publishing_options = {
    enabled = "true"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = data.aws_iam_policy_document.allow_access_to_the_domain_from_specific_ips.json

  tags = {
    Owner = "sysops"
    env   = "dev"
  }
}

