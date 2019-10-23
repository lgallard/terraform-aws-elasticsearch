resource "aws_elasticsearch_domain" "es_domain" {
  # Domain name
  domain_name = var.domain_name

  # ElasticSeach version
  elasticsearch_version = var.es_version

  # access_policies
  access_policies = var.access_policies

  # advanced_options
  advanced_options = var.advanced_options == null ? {} : var.advanced_options

  # ebs_options
  dynamic "ebs_options" {
    for_each = local.ebs_options
    content {
      ebs_enabled = lookup(ebs_options.value, "ebs_enabled ", var.ebs_enabled)
      volume_type = lookup(ebs_options.value, "volume_type ", var.ebs_options_volume_type)
      volume_size = lookup(ebs_options.value, "volume_size", var.ebs_options_volume_size)
      iops        = lookup(ebs_options.value, "iops", var.ebs_options_iops)
    }
  }

  # encrypt_at_rest
  dynamic "encrypt_at_rest" {
    for_each = local.encrypt_at_rest
    content {
      enabled    = lookup(encrypt_at_rest.value, "enabled ", var.encrypt_at_rest_enabled)
      kms_key_id = lookup(encrypt_at_rest.value, "kms_key_id ", var.encrypt_at_rest_kms_key_id)
    }
  }

  # node_to_node_encryption
  dynamic "node_to_node_encryption" {
    for_each = local.node_to_node_encryption
    content {
      enabled = lookup(node_to_node_encryption.value, "enabled ", var.node_to_node_encryption)
    }
  }

  # cluster_config
  dynamic "cluster_config" {
    for_each = local.cluster_config
    content {
      instance_type            = lookup(cluster_config.value, "instance_type", var.cluster_instance_type)
      instance_count           = lookup(cluster_config.value, "instance_count", var.cluster_instance_count)
      dedicated_master_enabled = lookup(cluster_config.value, "dedicated_master_enabled", var.cluster_dedicated_master_enabled)
      dedicated_master_type    = lookup(cluster_config.value, "dedicated_master_type", var.cluster_dedicated_master_type)
      dedicated_master_count   = lookup(cluster_config.value, "dedicated_master_count", var.cluster_dedicated_master_count)
      zone_awareness_enabled   = lookup(cluster_config.value, "zone_awareness_enabled ", var.cluster_zone_awareness_enabled)

      # zone_awareness_config
      dynamic "zone_awareness_config" {
        for_each = lookup(cluster_config.value, "zone_awareness_enabled ", var.cluster_zone_awareness_enabled) == false || length(lookup(cluster_config.value, "zone_awareness_config")) == 0 || lookup(cluster_config.value, "zone_awareness_config") == null ? [] : [lookup(cluster_configs.value, "zone_awareness_config", {})]
        content {
          availability_zone_count = lookup(zone_awareness_config.value, "availability_zone_count", var.cluster_availability_zone_count)
        }
      }
    }
  }

  # snapshot_options
  dynamic "snapshot_options" {
    for_each = local.snapshot_options
    content {
      automated_snapshot_start_hour = lookup(snapshot_options.value, "automated_snapshot_start_hour", var.snapshot_options_automated_snapshot_start_hour)
    }
  }

  # vpc_options
  dynamic "vpc_options" {
    for_each = local.vpc_options
    content {
      security_group_ids = lookup(vpc_options.value, "security_group_ids", var.vpc_options_security_group_ids)
      subnet_ids         = lookup(vpc_options.value, "subnet_ids", var.vpc_options_subnet_ids)
    }
  }

  # log_publishing_options
  dynamic "log_publishing_options" {
    for_each = local.log_publishing_options
    content {
      log_type                 = lookup(log_publishing_options.value, "log_type", var.log_publishing_options_log_type)
      cloudwatch_log_group_arn = lookup(log_publishing_options.value, "cloudwatch_log_group_arn", var.log_publishing_options_cloudwatch_log_group_arn)
      enabled                  = lookup(log_publishing_options.value, "enabled", var.log_publishing_options_enabled)
    }
  }

  # cognito_options
  dynamic "cognito_options" {
    for_each = local.cognito_options
    content {
      enabled          = lookup(cognito_options.value, "enabled", var.cognito_options_enabled)
      user_pool_id     = lookup(cognito_options.value, "user_pool_id", var.cognito_options_user_pool_id)
      identity_pool_id = lookup(cognito_options.value, "identity_pool_id ", var.cognito_options_identity_pool_id)
      role_arn         = lookup(cognito_options.value, "role_arn", var.cognito_options_role_arn)
    }
  }

}

locals {

  # ebs_options
  # If no ebs_options is provided, build a ebs_options using the default values
  ebs_option_default = var.ebs_options != null ? var.ebs_options : {
    ebs_enabled = var.ebs_enabled
    volume_type = var.ebs_options_volume_type
    volume_size = var.ebs_options_volume_size
    iops        = var.ebs_options_iops
  }

  ebs_options = lookup(local.ebs_option_default, "ebs_enabled", false) == false ? [] : [ebs_option_default]

  # encrypt_at_rest
  # If no encrypt_at_rest list is provided, build a encrypt_at_rest using the default values
  encrypt_at_rest_default = var.encrypt_at_rest != null ? var.encrypt_at_rest : {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_kms_key_id
  }

  encrypt_at_rest = lookup(local.encrypt_at_rest_default, "enabled", false) == false ? [] : [local.encrypt_at_rest_default]

  # node_to_node_encryption
  # If no node_to_node_encryption list is provided, build a node_to_node_encryption using the default values
  node_to_node_encryption_default = var.node_to_node_encryption != null ? var.node_to_node_encryption : {
    enabled = var.node_to_node_encryption_enabled
  }

  node_to_node_encryption = lookup(local.node_to_node_encryption_default, "enabled", false) == false ? [] : [local.node_to_node_encryption_default]

  # cluster_config
  # If no cluster_config list is provided, build a cluster_config using the default values
  cluster_config_default = var.cluster_config != null ? var.cluster_config : {
    instance_type            = var.cluster_instance_type
    instance_count           = var.cluster_instance_count
    dedicated_master_enabled = var.cluster_dedicated_master_enabled
    dedicated_master_type    = var.cluster_dedicated_master_type
    dedicated_master_count   = var.cluster_dedicated_master_count

    # cluster_availability_zone_count valid values: 2 or 3.
    zone_awareness_config = ! contains([2, 3], var.cluster_availability_zone_count) ? {} : {
      availability_zone_count = var.cluster_availability_zone_count
      zone_awareness_enabled  = true
    }
  }

  cluster_config = [cluster_config_default]

  # snapshot_options
  # If no snapshot_options list is provided, build a snapshot_options using the default values
  snapshot_options_default = var.snapshot_options != null ? var.snapshot_options : {
    automated_snapshot_start_hour = var.snapshot_options_automated_snapshot_start_hour
  }

  snapshot_options = [local.snapshot_options_default]

  # vpc_options
  # If no vpc_options list is provided, build a vpc_options using the default values
  vpc_options_default = var.vpc_options != null ? var.vpc_options : {
    security_group_ids = var.vpc_options_security_group_ids
    subnet_ids         = var.vpc_options_subnet_ids
  }

  vpc_options = lookup(local.vpc_options_default, "subnet_ids", null) == null ? [] : [local.vpc_options_default]

  # log_publishing_options
  # If no log_publishing_options list is provided, build a log_publishing_options using the default values
  log_publishing_options_default = var.log_publishing_options != null ? var.log_publishing_options : {
    log_type                 = var.log_publishing_options_log_type
    cloudwatch_log_group_arn = var.log_publishing_options_cloudwatch_log_group_arn
    enabled                  = var.log_publishing_options_enabled
  }

  log_publishing_options = lookup(local.log_publishing_options_default, "enabled", null) == null ? [] : [local.log_publishing_options_default]

  # cognito_options
  # If no cognito_options list is provided, build a cognito_options using the default values
  cognito_options_default = var.cognito_options != null ? var.cognito_options : {
    enabled          = var.cognito_options_enabled
    user_pool_id     = var.cognito_options_user_pool_id
    identity_pool_id = var.cognito_options_identity_pool_id
    role_arn         = var.cognito_options_role_arn
  }

  cognito_options = lookup(local.cognito_options_default, "enabled", null) == null ? [] : [local.cognito_options_default]

}
