resource "aws_elasticsearch_domain" "es_domain" {

  count = var.enabled ? 1 : 0

  # Domain name
  domain_name = var.domain_name

  # ElasticSeach version
  elasticsearch_version = var.elasticsearch_version

  # access_policies
  access_policies = var.access_policies

  # advanced_options
  advanced_options = var.advanced_options == null ? {} : var.advanced_options

  # advanced_security_options
  dynamic "advanced_security_options" {
    for_each = local.advanced_security_options
    content {
      enabled                        = lookup(advanced_security_options.value, "enabled")
      internal_user_database_enabled = lookup(advanced_security_options.value, "internal_user_database_enabled")

      master_user_options {
        master_user_arn      = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_arn", null)
        master_user_name     = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_name", null)
        master_user_password = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_password", null)
      }
    }
  }

  # auto_tune_options
  dynamic "auto_tune_options" {
    for_each = local.auto_tune_options
    content {
      desired_state = lookup(auto_tune_options.value, "desired_state")

      dynamic "maintenance_schedule" {
        for_each = auto_tune_options.value.maintenance_schedule
        content {
          start_at = lookup(maintenance_schedule.value, "start_at")
          duration {
            value = lookup(maintenance_schedule.value.duration, "value")
            unit = lookup(maintenance_schedule.value.duration, "unit")
          }
          cron_expression_for_recurrence = lookup(maintenance_schedule.value, "cron_expression_for_recurrence")
        }
      }
    }
  }

  # domain_endpoint_options
  dynamic "domain_endpoint_options" {
    for_each = local.domain_endpoint_options
    content {
      enforce_https                   = lookup(domain_endpoint_options.value, "enforce_https")
      tls_security_policy             = lookup(domain_endpoint_options.value, "tls_security_policy")
      custom_endpoint_enabled         = lookup(domain_endpoint_options.value, "custom_endpoint_enabled")
      custom_endpoint                 = lookup(domain_endpoint_options.value, "custom_endpoint")
      custom_endpoint_certificate_arn = lookup(domain_endpoint_options.value, "custom_endpoint_certificate_arn")
    }
  }

  # ebs_options
  dynamic "ebs_options" {
    for_each = local.ebs_options
    content {
      ebs_enabled = lookup(ebs_options.value, "ebs_enabled")
      volume_type = lookup(ebs_options.value, "volume_type")
      volume_size = lookup(ebs_options.value, "volume_size")
      iops        = lookup(ebs_options.value, "iops")
    }
  }

  # encrypt_at_rest
  dynamic "encrypt_at_rest" {
    for_each = local.encrypt_at_rest
    content {
      enabled    = lookup(encrypt_at_rest.value, "enabled")
      kms_key_id = lookup(encrypt_at_rest.value, "kms_key_id")
    }
  }

  # node_to_node_encryption
  dynamic "node_to_node_encryption" {
    for_each = local.node_to_node_encryption
    content {
      enabled = lookup(node_to_node_encryption.value, "enabled")
    }
  }

  # cluster_config
  dynamic "cluster_config" {
    for_each = local.cluster_config
    content {
      instance_type            = lookup(cluster_config.value, "instance_type")
      instance_count           = lookup(cluster_config.value, "instance_count")
      dedicated_master_enabled = lookup(cluster_config.value, "dedicated_master_enabled")
      dedicated_master_type    = lookup(cluster_config.value, "dedicated_master_type")
      dedicated_master_count   = lookup(cluster_config.value, "dedicated_master_count")
      zone_awareness_enabled   = lookup(cluster_config.value, "zone_awareness_enabled")
      warm_enabled             = lookup(cluster_config.value, "warm_enabled")
      warm_count               = lookup(cluster_config.value, "warm_count")
      warm_type                = lookup(cluster_config.value, "warm_type")

      dynamic "cold_storage_options" {
        for_each = lookup(cluster_config.value, "cold_storage_options_enabled", false) ? [1] : []
        content {
          enabled = lookup(cluster_config.value, "cold_storage_options_enabled", false)
        }
      }

      dynamic "zone_awareness_config" {
        # cluster_availability_zone_count valid values: 2 or 3.
        for_each = lookup(cluster_config.value, "zone_awareness_enabled", false) ? [1] : []
        content {
          availability_zone_count = lookup(cluster_config.value, "availability_zone_count")

        }
      }
    }
  }

  # snapshot_options
  dynamic "snapshot_options" {
    for_each = local.snapshot_options
    content {
      automated_snapshot_start_hour = lookup(snapshot_options.value, "automated_snapshot_start_hour")
    }
  }

  # vpc_options
  dynamic "vpc_options" {
    for_each = local.vpc_options
    content {
      security_group_ids = lookup(vpc_options.value, "security_group_ids")
      subnet_ids         = lookup(vpc_options.value, "subnet_ids")
    }
  }

  # log_publishing_options
  dynamic "log_publishing_options" {
    for_each = { for k, v in var.log_publishing_options :
      k => v if var.enabled && lookup(v, "enabled", false)
    }
    content {
      log_type                 = upper(log_publishing_options.key)
      cloudwatch_log_group_arn = lookup(log_publishing_options.value, "cloudwatch_log_group_arn", null) != null ? lookup(log_publishing_options.value, "cloudwatch_log_group_arn") : aws_cloudwatch_log_group.es_cloudwatch_log_group[log_publishing_options.key].arn
      enabled                  = lookup(log_publishing_options.value, "enabled")
    }
  }

  # cognito_options
  dynamic "cognito_options" {
    for_each = local.cognito_options
    content {
      enabled          = lookup(cognito_options.value, "enabled")
      user_pool_id     = lookup(cognito_options.value, "user_pool_id")
      identity_pool_id = lookup(cognito_options.value, "identity_pool_id")
      role_arn         = lookup(cognito_options.value, "role_arn")
    }
  }

  # Timeouts
  dynamic "timeouts" {
    for_each = local.timeouts
    content {
      update = lookup(timeouts.value, "update")
    }
  }

  # Tags
  tags = var.tags

  # Service-linked role to give Amazon ES permissions to access your VPC
  depends_on = [aws_iam_service_linked_role.es, aws_cloudwatch_log_group.es_cloudwatch_log_group]

}

resource "random_password" "master_password" {
  count = local.create_random_master_password ? 1 : 0

  length  = var.advanced_security_options_random_master_password_length
  special = true
}

locals {
  # advanced_security_options
  # Create subblock master_user_options
  create_random_master_password = var.advanced_security_options_enabled && var.advanced_security_options_internal_user_database_enabled && var.advanced_security_options_create_random_master_password
  master_user_arn               = var.advanced_security_options_internal_user_database_enabled == false ? var.advanced_security_options_master_user_arn : null
  master_user_name              = var.advanced_security_options_internal_user_database_enabled == true ? var.advanced_security_options_master_user_username : null
  master_user_password          = local.create_random_master_password == true ? random_password.master_password[0].result : var.advanced_security_options_master_user_password

  master_user_options = lookup(var.advanced_security_options, "master_user_options", null) != null ? lookup(var.advanced_security_options, "master_user_options") : {
    master_user_arn      = local.master_user_arn
    master_user_name     = local.master_user_name
    master_user_password = local.master_user_password
  }

  # If advanced_security_options is provided, build an advanced_security_options using the default values
  advanced_security_options_default = {
    enabled                        = lookup(var.advanced_security_options, "enabled", null) == null ? var.advanced_security_options_enabled : lookup(var.advanced_security_options, "enabled")
    internal_user_database_enabled = lookup(var.advanced_security_options, "internal_user_database_enabled", null) == null ? var.advanced_security_options_internal_user_database_enabled : lookup(var.advanced_security_options, "internal_user_database_enabled")
    master_user_options            = local.master_user_options
  }

  advanced_security_options = lookup(local.advanced_security_options_default, "enabled", false) == false ? [] : [local.advanced_security_options_default]

  # Create subblock master_user_options
  auto_tune_state = try(var.auto_tune_options.desired_state, var.auto_tune_options_desired_state, "ENABLED")

  maintenance_schedule_enabled = local.auto_tune_state == "ENABLED" && (try(var.auto_tune_options.rollback_on_disable, var.auto_tune_options_rollback_on_disable, "NO_ROLLBACK") == "DEFAULT_ROLLBACK" || try(var.auto_tune_options.maintenance_schedule.start_at, var.auto_tune_options_start_at, null) != null)
  
  start_at = try(var.auto_tune_options.maintenance_schedule.start_at, var.auto_tune_options_start_at, null)

  duration_value = try(var.auto_tune_options.maintenance_schedule.duration.value, var.auto_tune_options_duration_value, null)

  duration_unit = "HOURS"

  duration = {
    value = local.duration_value
    unit = local.duration_unit
  }

  cron_expression_for_recurrence = try(var.auto_tune_options.maintenance_schedule.cron_expression_for_recurrence, var.auto_tune_options_cron_expression_for_recurrence, null)

  maintenance_schedule = {
    start_at = local.start_at
    duration = local.duration
    cron_expression_for_recurrence = local.cron_expression_for_recurrence
  }

  rollback_on_disable = try(var.auto_tune_options.maintenance_schedule.rollback_on_disable, var.auto_tune_options_rollback_on_disable, "NO_ROLLBACK")
    
  # If auto_tune_options is provided, build an auto_tune_options using the default values
  auto_tune_options_default = {
    desired_state = local.auto_tune_state
    maintenance_schedule = local.maintenance_schedule_enabled ? [local.maintenance_schedule] : []
    rollback_on_disable = local.rollback_on_disable
  }

  auto_tune_options = local.auto_tune_state == "ENABLED" ? [local.auto_tune_options_default] : []

  # If domain_endpoint_options is provided, build an domain_endpoint_options using the default values
  domain_endpoint_options_default = {
    enforce_https       = lookup(var.domain_endpoint_options, "enforce_https", null) == null ? var.domain_endpoint_options_enforce_https : lookup(var.domain_endpoint_options, "enforce_https")
    tls_security_policy = lookup(var.domain_endpoint_options, "tls_security_policy", null) == null ? var.domain_endpoint_options_tls_security_policy : lookup(var.domain_endpoint_options, "tls_security_policy")

    # custom_endpoint
    custom_endpoint_enabled         = lookup(var.domain_endpoint_options, "custom_endpoint_enabled", null) == null ? var.domain_endpoint_options_custom_endpoint_enabled : lookup(var.domain_endpoint_options, "custom_endpoint_enabled")
    custom_endpoint                 = lookup(var.domain_endpoint_options, "custom_endpoint", null) == null ? var.domain_endpoint_options_custom_endpoint : lookup(var.domain_endpoint_options, "custom_endpoint")
    custom_endpoint_certificate_arn = lookup(var.domain_endpoint_options, "custom_endpoint_certificate_arn", null) == null ? var.domain_endpoint_options_custom_endpoint_certificate_arn : lookup(var.domain_endpoint_options, "custom_endpoint_certificate_arn")
  }

  domain_endpoint_options = lookup(local.domain_endpoint_options_default, "enforce_https", false) == false ? [] : [local.domain_endpoint_options_default]

  # ebs_options
  # If no ebs_options is provided, build an ebs_options using the default values
  ebs_option_default = {
    ebs_enabled = lookup(var.ebs_options, "ebs_enabled", null) == null ? var.ebs_enabled : lookup(var.ebs_options, "ebs_enabled")
    volume_type = lookup(var.ebs_options, "volume_type", null) == null ? var.ebs_options_volume_type : lookup(var.ebs_options, "volume_type")
    volume_size = lookup(var.ebs_options, "volume_size", null) == null ? var.ebs_options_volume_size : lookup(var.ebs_options, "volume_size")
    iops        = lookup(var.ebs_options, "iops", null) == null ? var.ebs_options_iops : lookup(var.ebs_options, "iops")
  }

  ebs_options = var.ebs_enabled == false || lookup(local.ebs_option_default, "ebs_enabled", false) == false ? [] : [local.ebs_option_default]

  # encrypt_at_rest
  # If no encrypt_at_rest list is provided, build a encrypt_at_rest using the default values

  encrypt_at_rest_default = {
    enabled    = lookup(var.encrypt_at_rest, "enabled", null) == null ? var.encrypt_at_rest_enabled : lookup(var.encrypt_at_rest, "enabled")
    kms_key_id = lookup(var.encrypt_at_rest, "kms_key_id", null) == null ? data.aws_kms_key.aws_es.arn : lookup(var.encrypt_at_rest, "kms_key_id")
  }

  encrypt_at_rest = var.encrypt_at_rest_enabled == false || lookup(local.encrypt_at_rest_default, "enabled", false) == false ? [] : [local.encrypt_at_rest_default]

  # node_to_node_encryption
  # If no node_to_node_encryption list is provided, build a node_to_node_encryption using the default values
  node_to_node_encryption_default = {
    enabled = lookup(var.node_to_node_encryption, "enabled", null) == null ? var.node_to_node_encryption_enabled : lookup(var.node_to_node_encryption, "enabled")
  }

  node_to_node_encryption = var.node_to_node_encryption_enabled == false || lookup(local.node_to_node_encryption_default, "enabled", false) == false ? [] : [local.node_to_node_encryption_default]

  # cluster_config
  # If no cluster_config list is provided, build a cluster_config using the default values
  cluster_config_default = {
    instance_type                = lookup(var.cluster_config, "instance_type", null) == null ? var.cluster_config_instance_type : lookup(var.cluster_config, "instance_type")
    instance_count               = lookup(var.cluster_config, "instance_count", null) == null ? var.cluster_config_instance_count : lookup(var.cluster_config, "instance_count")
    dedicated_master_enabled     = lookup(var.cluster_config, "dedicated_master_enabled", null) == null ? var.cluster_config_dedicated_master_enabled : lookup(var.cluster_config, "dedicated_master_enabled")
    dedicated_master_type        = lookup(var.cluster_config, "dedicated_master_type", null) == null ? var.cluster_config_dedicated_master_type : lookup(var.cluster_config, "dedicated_master_type")
    dedicated_master_count       = lookup(var.cluster_config, "dedicated_master_count", null) == null ? var.cluster_config_dedicated_master_count : lookup(var.cluster_config, "dedicated_master_count")
    zone_awareness_enabled       = lookup(var.cluster_config, "zone_awareness_enabled", null) == null ? var.cluster_config_zone_awareness_enabled : lookup(var.cluster_config, "zone_awareness_enabled")
    availability_zone_count      = lookup(var.cluster_config, "availability_zone_count", null) == null ? var.cluster_config_availability_zone_count : lookup(var.cluster_config, "availability_zone_count")
    warm_enabled                 = lookup(var.cluster_config, "warm_enabled", null) == null ? var.cluster_config_warm_enabled : lookup(var.cluster_config, "warm_enabled")
    warm_count                   = lookup(var.cluster_config, "warm_count", null) == null ? var.cluster_config_warm_count : lookup(var.cluster_config, "warm_count")
    warm_type                    = lookup(var.cluster_config, "warm_type", null) == null ? var.cluster_config_warm_type : lookup(var.cluster_config, "warm_type")
    cold_storage_options_enabled = lookup(var.cluster_config, "cold_storage_options_enabled", null) == null ? var.cluster_config_cold_storage_options_enabled : lookup(var.cluster_config, "cold_storage_options_enabled")
  }

  cluster_config = [local.cluster_config_default]

  # snapshot_options
  # If no snapshot_options list is provided, build a snapshot_options using the default values
  snapshot_options_default = {
    automated_snapshot_start_hour = lookup(var.snapshot_options, "automated_snapshot_start_hour", null) == null ? var.snapshot_options_automated_snapshot_start_hour : lookup(var.snapshot_options, "automated_snapshot_start_hour")
  }

  snapshot_options = [local.snapshot_options_default]

  # vpc_options
  # If no vpc_options list is provided, build a vpc_options using the default values
  vpc_options_default = {
    security_group_ids = lookup(var.vpc_options, "security_group_ids", null) == null ? var.vpc_options_security_group_ids : lookup(var.vpc_options, "security_group_ids")
    subnet_ids         = lookup(var.vpc_options, "subnet_ids", null) == null ? var.vpc_options_subnet_ids : lookup(var.vpc_options, "subnet_ids")
  }

  vpc_options = length(lookup(local.vpc_options_default, "subnet_ids")) == 0 ? [] : [local.vpc_options_default]

  # cognito_options
  # If no cognito_options list is provided, build a cognito_options using the default values
  cognito_options_default = {
    enabled          = lookup(var.cognito_options, "enabled", null) == null ? var.cognito_options_enabled : lookup(var.cognito_options, "enabled")
    user_pool_id     = lookup(var.cognito_options, "user_pool_id", null) == null ? var.cognito_options_user_pool_id : lookup(var.cognito_options, "user_pool_id")
    identity_pool_id = lookup(var.cognito_options, "identity_pool_id", null) == null ? var.cognito_options_identity_pool_id : lookup(var.cognito_options, "identity_pool_id")
    role_arn         = lookup(var.cognito_options, "role_arn", null) == null ? var.cognito_options_role_arn : lookup(var.cognito_options, "role_arn")
  }

  cognito_options = var.cognito_options_enabled == false || lookup(local.cognito_options_default, "enabled", false) == false ? [] : [local.cognito_options_default]

  # Timeouts
  # If timeouts block is provided, build one using the default values
  timeouts = var.timeouts_update == null && length(var.timeouts) == 0 ? [] : [
    {
      update = lookup(var.timeouts, "update", null) == null ? var.timeouts_update : lookup(var.timeouts, "update")
    }
  ]


}
