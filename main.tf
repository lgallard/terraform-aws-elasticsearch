resource "aws_elasticsearch_domain" "es_domain" {
  domain_name           = var.domain_name
  elasticsearch_version = var.es_version

  dynamic "cluster_config" {
    for_each = local.cluster_configs
    content {
      instance_type            = lookup(cluster_configs.value, "instance_type", var.cluster_instance_type)
      instance_count           = lookup(cluster_configs.value, "instance_count", var.cluster_instance_count)
      dedicated_master_enabled = lookup(cluster_configs.value, "dedicated_master_enabled", var.cluster_dedicated_master_enabled)
      dedicated_master_type    = lookup(cluster_configs.value, "dedicated_master_type", var.cluster_dedicated_master_type)
      dedicated_master_count   = lookup(cluster_configs.value, "dedicated_master_count", var.cluster_dedicated_master_count)
      zone_awareness_enabled   = lookup(cluster_configs.value, "zone_awareness_enabled ", var.cluster_zone_awareness_enabled)

      # zone_awareness_config
      dynamic "zone_awareness_config" {
        for_each = lookup(cluster_configs.value, "zone_awareness_enabled ", var.cluster_zone_awareness_enabled) == false || length(lookup(cluster_configs.value, "zone_awareness_config")) == 0 || lookup(cluster_configs.value, "zone_awareness_config") == null ? [] : [lookup(cluster_configs.value, "zone_awareness_config", {})]
        content {
          availability_zone_count = lookup(zone_awareness_config.value, "availability_zone_count", var.cluster_availability_zone_count)
        }
      }

    }
  }

}

locals {

  # If no cluster_config list is provided, build a cluster_config using the default values
  cluster_config = var.cluster_config != null ? [] : [
    {

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

  }]

  cluster_configs = concat(local.cluster_config, var.cluster_config)

}
