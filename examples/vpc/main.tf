module "aws_es" {

  source = "lgallard/elasticsearch/aws"

  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config = {
    dedicated_master_enabled = true
    instance_count           = 3
    instance_type            = "r5.large.elasticsearch"
    zone_awareness_enabled   = true
    availability_zone_count  = 3
  }

  ebs_options = {
    ebs_enabled = true
    volume_size = 25
  }

  encrypt_at_rest = {
    enabled    = true
    kms_key_id = "arn:aws:kms:us-east-1:123456789101:key/cccc103b-4ba3-5993-6fc7-b7e538b25fd8"
  }

  vpc_options = {
    subnet_ids         = ["subnet-09999999999999999", "subnet-02222222222222222", "subnet-05555555555555555"]
    security_group_ids = ["sg-03333333333333333"]
  }

  node_to_node_encryption_enabled                = true
  snapshot_options_automated_snapshot_start_hour = 23

  access_policies = templatefile("${path.module}/access_policies.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.es_domain_name
  })

  timeouts_update = "60m"

  tags = {
    Owner = "sysops"
    env   = "dev"
  }
}
