#
# AWS ElasticSearch
#
variable "domain_name" {
  description = "Name of the domain"
  type        = string
}

variable "es_version" {
  description = "The version of Elasticsearch to deploy."
  type        = string
  defualt     = "7.1"
}

# cluster_config 
variable "cluster_instance_type" {
  description = "Instance type of data nodes in the cluster"
  type        = string
  default     = "r5.large.elasticsearch"
}

variable "cluster_instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 3
}

variable "cluster_dedicated_master_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
  type        = bool
  default     = true
}

variable "cluster_dedicated_master_type" {
  description = "Instance type of the dedicated master nodes in the cluster"
  type        = string
  default     = "r5.large.elasticsearch"
}

variable "cluster_dedicated_master_count" {
  description = "Number of dedicated master nodes in the cluster"
  type        = number
  default     = 3
}

variable "cluster_availability_zone_count" {
  description = "Number of Availability Zones for the domain to use with"
  type        = number
  default     = 3
}
