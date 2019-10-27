module "aws_es" {

  source = "lgallard/elasticsearch/aws"

  domain_name           = "elasticsearch_public"
  elasticsearch_version = "7.1"

  encrypt_at_rest_enabled                        = "true"
  node_to_node_encryption_enabled                = "true"
  snapshot_options_automated_snapshot_start_hour = "23"

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

  log_publishing_options = {
    enabled = "true"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = templatefile("${path.module}/whitelist.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.es_domain_name,
    whitelist   = "${jsonencode(var.whitelist)}"
  })

  tags = {
    Owner = "sysops"
    env   = "dev"
  }
}
