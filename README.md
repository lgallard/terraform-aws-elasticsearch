![Terraform](https://lgallardo.com/images/terraform.jpg)
# terraform-aws-elasticsearch

Terraform module to create [Amazon Elasticsearch Service](https://aws.amazon.com/elasticsearch-service/) clusters, following the Well-Architected Framework and best AWS practices.

Amazon Elasticsearch Service is a fully managed service that makes it easy to deploy, operate, and scale Elasticsearch clusters in the AWS Cloud. Elasticsearch is a popular open-source search and analytics engine for use cases such as log analytics, real-time application monitoring, and clickstream analysis. With Amazon ES, you get direct access to the Elasticsearch APIs; existing code and applications work seamlessly with the service.

## Examples

Check the [examples](/examples/) folder where you can see how to configure a public ES cluster, and another example showing how to set it with VPC options.

## Usage

You can use this module to create your Amazon ES cluster by defining each parameters blocks as follows:

```
module "aws_es" {

  source  = "lgallard/elasticsearch/aws"

  domain_name           = "elasticsearch_public"
  elasticsearch_version = "7.1"

  cluster_config = {
    dedicated_master_enabled = true
    instance_count           = 3
    instance_type            = "r5.large.elasticsearch"
    zone_awareness_enabled   = true
    availability_zone_count  = 3
  }

  ebs_options = {
    ebs_enabled = "true"
    volume_size = "25"
  }

  encrypt_at_rest = {
    enabled    = true
    kms_key_id = "arn:aws:kms:us-east-1:123456789101:key/cccc103b-4ba3-5993-6fc7-b7e538b25fd8"
  }

  log_publishing_options = {
    enabled                  = true
    log_type                 = "INDEX_SLOW_LOGS"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = true
  }

  domain_endpoint_options = {
    enforce_https                   = true
    custom_endpoint_enabled         = true
    custom_endpoint                 = "lgallardo.com"
    custom_endpoint_certificate_arn = "arn:aws:acm:us-east-1:123456789101:certificate/abcd1234-ef11-abcd-1234-abcd1234efef"
  }

  node_to_node_encryption_enabled                = true
  snapshot_options_automated_snapshot_start_hour = 23

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

```

**Note:** You can also define the above ElasticSearch cluster using just the module variables. Instead of defining a `cluster_config` block (list of map), you can set each of the `cluster_config_*` variables, as shown below:

```
module "aws_es" {

  source  = "lgallard/elasticsearch/aws"

  domain_name           = "elasticsearch_public"
  elasticsearch_version = "7.1"

  cluster_config_dedicated_master_enabled = true
  cluster_config_instance_count           = 3
  cluster_config_instance_type            = "r5.large.elasticsearch"
  cluster_config_zone_awareness_enabled   = "true"
  cluster_config_availability_zone_count  = 3

  ebs_options_ebs_enabled = true
  ebs_options_volume_size = 25

  encrypt_at_rest_enabled    = true
  encrypt_at_rest_kms_key_id = "alias/aws/es"

  log_publishing_options_enabled  = true
  log_publishing_options_log_type = "INDEX_SLOW_LOGS"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = true
  }

  node_to_node_encryption_enabled                = true
  snapshot_options_automated_snapshot_start_hour = 23

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.es_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.es_aws_cloudwatch_log_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_elasticsearch_domain.es_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_iam_service_linked_role.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_kms_key.aws_es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | IAM policy document specifying the access policies for the domain | `string` | `""` | no |
| <a name="input_advanced_options"></a> [advanced\_options](#input\_advanced\_options) | Key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply | `map(string)` | `{}` | no |
| <a name="input_advanced_security_options"></a> [advanced\_security\_options](#input\_advanced\_security\_options) | Options for fine-grained access control | `any` | `{}` | no |
| <a name="input_advanced_security_options_enabled"></a> [advanced\_security\_options\_enabled](#input\_advanced\_security\_options\_enabled) | Whether advanced security is enabled (Forces new resource) | `bool` | `false` | no |
| <a name="input_advanced_security_options_internal_user_database_enabled"></a> [advanced\_security\_options\_internal\_user\_database\_enabled](#input\_advanced\_security\_options\_internal\_user\_database\_enabled) | Whether the internal user database is enabled. If not set, defaults to false by the AWS API. | `bool` | `false` | no |
| <a name="input_advanced_security_options_master_user_arn"></a> [advanced\_security\_options\_master\_user\_arn](#input\_advanced\_security\_options\_master\_user\_arn) | ARN for the master user. Only specify if `internal_user_database_enabled` is not set or set to `false`) | `string` | `null` | no |
| <a name="input_advanced_security_options_master_user_password"></a> [advanced\_security\_options\_master\_user\_password](#input\_advanced\_security\_options\_master\_user\_password) | The master user's password, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if `internal_user_database_enabled` is set to `true`. | `string` | `null` | no |
| <a name="input_advanced_security_options_master_user_username"></a> [advanced\_security\_options\_master\_user\_username](#input\_advanced\_security\_options\_master\_user\_username) | The master user's username, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if `internal_user_database_enabled` is set to `true`. | `string` | `null` | no |
| <a name="input_cloudwatch_log_enabled"></a> [cloudwatch\_log\_enabled](#input\_cloudwatch\_log\_enabled) | Change to false to avoid deploying any Cloudwatch Logs resources | `bool` | `true` | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Cluster configuration of the domain | `any` | `{}` | no |
| <a name="input_cluster_config_availability_zone_count"></a> [cluster\_config\_availability\_zone\_count](#input\_cluster\_config\_availability\_zone\_count) | Number of Availability Zones for the domain to use with | `number` | `3` | no |
| <a name="input_cluster_config_dedicated_master_count"></a> [cluster\_config\_dedicated\_master\_count](#input\_cluster\_config\_dedicated\_master\_count) | Number of dedicated master nodes in the cluster | `number` | `3` | no |
| <a name="input_cluster_config_dedicated_master_enabled"></a> [cluster\_config\_dedicated\_master\_enabled](#input\_cluster\_config\_dedicated\_master\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster | `bool` | `true` | no |
| <a name="input_cluster_config_dedicated_master_type"></a> [cluster\_config\_dedicated\_master\_type](#input\_cluster\_config\_dedicated\_master\_type) | Instance type of the dedicated master nodes in the cluster | `string` | `"r5.large.elasticsearch"` | no |
| <a name="input_cluster_config_instance_count"></a> [cluster\_config\_instance\_count](#input\_cluster\_config\_instance\_count) | Number of instances in the cluster | `number` | `3` | no |
| <a name="input_cluster_config_instance_type"></a> [cluster\_config\_instance\_type](#input\_cluster\_config\_instance\_type) | Instance type of data nodes in the cluster | `string` | `"r5.large.elasticsearch"` | no |
| <a name="input_cluster_config_warm_count"></a> [cluster\_config\_warm\_count](#input\_cluster\_config\_warm\_count) | The number of warm nodes in the cluster | `number` | `null` | no |
| <a name="input_cluster_config_warm_enabled"></a> [cluster\_config\_warm\_enabled](#input\_cluster\_config\_warm\_enabled) | Indicates whether to enable warm storage | `bool` | `false` | no |
| <a name="input_cluster_config_warm_type"></a> [cluster\_config\_warm\_type](#input\_cluster\_config\_warm\_type) | The instance type for the Elasticsearch cluster's warm nodes | `string` | `null` | no |
| <a name="input_cluster_config_zone_awareness_enabled"></a> [cluster\_config\_zone\_awareness\_enabled](#input\_cluster\_config\_zone\_awareness\_enabled) | Indicates whether zone awareness is enabled. To enable awareness with three Availability Zones | `bool` | `false` | no |
| <a name="input_cognito_options"></a> [cognito\_options](#input\_cognito\_options) | Options for Amazon Cognito Authentication for Kibana | `any` | `{}` | no |
| <a name="input_cognito_options_enabled"></a> [cognito\_options\_enabled](#input\_cognito\_options\_enabled) | Specifies whether Amazon Cognito authentication with Kibana is enabled or not | `bool` | `false` | no |
| <a name="input_cognito_options_identity_pool_id"></a> [cognito\_options\_identity\_pool\_id](#input\_cognito\_options\_identity\_pool\_id) | ID of the Cognito Identity Pool to use | `string` | `""` | no |
| <a name="input_cognito_options_role_arn"></a> [cognito\_options\_role\_arn](#input\_cognito\_options\_role\_arn) | ARN of the IAM role that has the AmazonESCognitoAccess policy attached | `string` | `""` | no |
| <a name="input_cognito_options_user_pool_id"></a> [cognito\_options\_user\_pool\_id](#input\_cognito\_options\_user\_pool\_id) | ID of the Cognito User Pool to use | `string` | `""` | no |
| <a name="input_create_service_link_role"></a> [create\_service\_link\_role](#input\_create\_service\_link\_role) | Create service link role for AWS Elasticsearch Service | `bool` | `true` | no |
| <a name="input_domain_endpoint_options"></a> [domain\_endpoint\_options](#input\_domain\_endpoint\_options) | Domain endpoint HTTP(S) related options. | `any` | `{}` | no |
| <a name="input_domain_endpoint_options_custom_endpoint"></a> [domain\_endpoint\_options\_custom\_endpoint](#input\_domain\_endpoint\_options\_custom\_endpoint) | Fully qualified domain for your custom endpoint | `string` | `null` | no |
| <a name="input_domain_endpoint_options_custom_endpoint_certificate_arn"></a> [domain\_endpoint\_options\_custom\_endpoint\_certificate\_arn](#input\_domain\_endpoint\_options\_custom\_endpoint\_certificate\_arn) | ACM certificate ARN for your custom endpoint | `string` | `null` | no |
| <a name="input_domain_endpoint_options_custom_endpoint_enabled"></a> [domain\_endpoint\_options\_custom\_endpoint\_enabled](#input\_domain\_endpoint\_options\_custom\_endpoint\_enabled) | Whether to enable custom endpoint for the Elasticsearch domain | `bool` | `false` | no |
| <a name="input_domain_endpoint_options_enforce_https"></a> [domain\_endpoint\_options\_enforce\_https](#input\_domain\_endpoint\_options\_enforce\_https) | Whether or not to require HTTPS | `bool` | `false` | no |
| <a name="input_domain_endpoint_options_tls_security_policy"></a> [domain\_endpoint\_options\_tls\_security\_policy](#input\_domain\_endpoint\_options\_tls\_security\_policy) | The name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: `Policy-Min-TLS-1-0-2019-07` and `Policy-Min-TLS-1-2-2019-07` | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the domain | `string` | n/a | yes |
| <a name="input_ebs_enabled"></a> [ebs\_enabled](#input\_ebs\_enabled) | Whether EBS volumes are attached to data nodes in the domain | `bool` | `true` | no |
| <a name="input_ebs_options"></a> [ebs\_options](#input\_ebs\_options) | EBS related options, may be required based on chosen instance size | `any` | `{}` | no |
| <a name="input_ebs_options_iops"></a> [ebs\_options\_iops](#input\_ebs\_options\_iops) | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type | `number` | `0` | no |
| <a name="input_ebs_options_volume_size"></a> [ebs\_options\_volume\_size](#input\_ebs\_options\_volume\_size) | The size of EBS volumes attached to data nodes (in GB). Required if ebs\_enabled is set to true | `number` | `10` | no |
| <a name="input_ebs_options_volume_type"></a> [ebs\_options\_volume\_type](#input\_ebs\_options\_volume\_type) | The type of EBS volumes attached to data nodes | `string` | `"gp2"` | no |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | The version of Elasticsearch to deploy. | `string` | `"7.1"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Change to false to avoid deploying any AWS ElasticSearch resources | `bool` | `true` | no |
| <a name="input_encrypt_at_rest"></a> [encrypt\_at\_rest](#input\_encrypt\_at\_rest) | Encrypt at rest options. Only available for certain instance types | `any` | `{}` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_encrypt_at_rest_kms_key_id"></a> [encrypt\_at\_rest\_kms\_key\_id](#input\_encrypt\_at\_rest\_kms\_key\_id) | The KMS key id to encrypt the Elasticsearch domain with. If not specified then it defaults to using the aws/es service KMS key | `string` | `"alias/aws/es"` | no |
| <a name="input_log_publishing_options"></a> [log\_publishing\_options](#input\_log\_publishing\_options) | Options for publishing slow logs to CloudWatch Logs | `any` | `{}` | no |
| <a name="input_log_publishing_options_cloudwatch_log_group_arn"></a> [log\_publishing\_options\_cloudwatch\_log\_group\_arn](#input\_log\_publishing\_options\_cloudwatch\_log\_group\_arn) | iARN of the Cloudwatch log group to which log needs to be published | `string` | `""` | no |
| <a name="input_log_publishing_options_enabled"></a> [log\_publishing\_options\_enabled](#input\_log\_publishing\_options\_enabled) | Specifies whether given log publishing option is enabled or not | `bool` | `true` | no |
| <a name="input_log_publishing_options_log_type"></a> [log\_publishing\_options\_log\_type](#input\_log\_publishing\_options\_log\_type) | A type of Elasticsearch log. Valid values: INDEX\_SLOW\_LOGS, SEARCH\_SLOW\_LOGS, ES\_APPLICATION\_LOGS | `string` | `"INDEX_SLOW_LOGS"` | no |
| <a name="input_log_publishing_options_retention"></a> [log\_publishing\_options\_retention](#input\_log\_publishing\_options\_retention) | Retention in days for the created Cloudwatch log group | `number` | `90` | no |
| <a name="input_node_to_node_encryption"></a> [node\_to\_node\_encryption](#input\_node\_to\_node\_encryption) | Node-to-node encryption options | `any` | `{}` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Whether to enable node-to-node encryption | `bool` | `true` | no |
| <a name="input_snapshot_options"></a> [snapshot\_options](#input\_snapshot\_options) | Snapshot related options | `any` | `{}` | no |
| <a name="input_snapshot_options_automated_snapshot_start_hour"></a> [snapshot\_options\_automated\_snapshot\_start\_hour](#input\_snapshot\_options\_automated\_snapshot\_start\_hour) | Hour during which the service takes an automated daily snapshot of the indices in the domain | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(any)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeouts map. | `map(any)` | `{}` | no |
| <a name="input_timeouts_update"></a> [timeouts\_update](#input\_timeouts\_update) | How long to wait for updates. | `string` | `null` | no |
| <a name="input_vpc_options"></a> [vpc\_options](#input\_vpc\_options) | VPC related options, see below. Adding or removing this configuration forces a new resource | `any` | `{}` | no |
| <a name="input_vpc_options_security_group_ids"></a> [vpc\_options\_security\_group\_ids](#input\_vpc\_options\_security\_group\_ids) | List of VPC Security Group IDs to be applied to the Elasticsearch domain endpoints. If omitted, the default Security Group for the VPC will be used | `list(any)` | `[]` | no |
| <a name="input_vpc_options_subnet_ids"></a> [vpc\_options\_subnet\_ids](#input\_vpc\_options\_subnet\_ids) | List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the domain |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the domain |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for kibana without https scheme |
| <a name="output_vpc_options_availability_zones"></a> [vpc\_options\_availability\_zones](#output\_vpc\_options\_availability\_zones) | If the domain was created inside a VPC, the names of the availability zones the configured subnet\_ids were created inside |
| <a name="output_vpc_options_vpc_id"></a> [vpc\_options\_vpc\_id](#output\_vpc\_options\_vpc\_id) | If the domain was created inside a VPC, the ID of the VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
