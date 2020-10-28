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
    enabled    = "true"
    kms_key_id = "alias/aws/es"
  }

  log_publishing_options = {
    enabled                  = "true"
    log_type                 = "INDEX_SLOW_LOGS"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  node_to_node_encryption_enabled                = "true"
  snapshot_options_automated_snapshot_start_hour = "23"

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

```

**Note:** You can also define the above ElasticSearch cluster using just the module variables. Instead of defining a `cluster_config` block (list of map), you can set each of the `cluster_config_*` variables, as shown below:

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

  encrypt_at_rest_enabled    = true
  encrypt_at_rest_kms_key_id = "alias/aws/es"

  log_publishing_options_enabled  = true
  log_publishing_options_log_type = "INDEX_SLOW_LOGS"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  node_to_node_encryption_enabled                = "true"
  snapshot_options_automated_snapshot_start_hour = "23"

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

```
## Providers

| Name | Version |
|------|---------|
| aws | >= 2.69.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_policies | IAM policy document specifying the access policies for the domain | `string` | `""` | no |
| advanced\_options | Key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply | `map(string)` | `{}` | no |
| advanced\_security\_options | Options for fine-grained access control | `any` | `{}` | no |
| advanced\_security\_options\_enabled | Whether advanced security is enabled (Forces new resource) | `bool` | `false` | no |
| advanced\_security\_options\_internal\_user\_database\_enabled | Whether the internal user database is enabled. If not set, defaults to false by the AWS API. | `bool` | `false` | no |
| advanced\_security\_options\_master\_user\_arn | ARN for the master user. Only specify if `internal_user_database_enabled` is not set or set to `false`) | `string` | n/a | yes |
| advanced\_security\_options\_master\_user\_password | The master user's password, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if `internal_user_database_enabled` is set to `true`. | `string` | n/a | yes |
| advanced\_security\_options\_master\_user\_username | The master user's username, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if `internal_user_database_enabled` is set to `true`. | `string` | n/a | yes |
| cluster\_config | Cluster configuration of the domain | `map` | `{}` | no |
| cluster\_config\_availability\_zone\_count | Number of Availability Zones for the domain to use with | `number` | `3` | no |
| cluster\_config\_dedicated\_master\_count | Number of dedicated master nodes in the cluster | `number` | `3` | no |
| cluster\_config\_dedicated\_master\_enabled | Indicates whether dedicated master nodes are enabled for the cluster | `bool` | `true` | no |
| cluster\_config\_dedicated\_master\_type | Instance type of the dedicated master nodes in the cluster | `string` | `"r5.large.elasticsearch"` | no |
| cluster\_config\_instance\_count | Number of instances in the cluster | `number` | `3` | no |
| cluster\_config\_instance\_type | Instance type of data nodes in the cluster | `string` | `"r5.large.elasticsearch"` | no |
| cluster\_config\_warm\_count | The number of warm nodes in the cluster | `number` | n/a | no |
| cluster\_config\_warm\_enabled | Indicates whether to enable warm storage | `bool` | `false` | no |
| cluster\_config\_warm\_type | The instance type for the Elasticsearch cluster's warm nodes | `string` | n/a | no |
| cluster\_config\_zone\_awareness\_enabled | Indicates whether zone awareness is enabled. To enable awareness with three Availability Zones | `bool` | `false` | no |
| cognito\_options | Options for Amazon Cognito Authentication for Kibana | `map` | `{}` | no |
| cognito\_options\_enabled | Specifies whether Amazon Cognito authentication with Kibana is enabled or not | `bool` | `false` | no |
| cognito\_options\_identity\_pool\_id | ID of the Cognito Identity Pool to use | `string` | `""` | no |
| cognito\_options\_role\_arn | ARN of the IAM role that has the AmazonESCognitoAccess policy attached | `string` | `""` | no |
| cognito\_options\_user\_pool\_id | ID of the Cognito User Pool to use | `string` | `""` | no |
| create\_service\_link\_role | Create service link role for AWS Elasticsearch Service | `bool` | `true` | no |
| domain\_endpoint\_options | Domain endpoint HTTP(S) related options. | `any` | `{}` | no |
| domain\_endpoint\_options\_enforce\_https | Whether or not to require HTTPS | `bool` | `false` | no |
| domain\_endpoint\_options\_tls\_security\_policy | The name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: `Policy-Min-TLS-1-0-2019-07` and `Policy-Min-TLS-1-2-2019-07` | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| domain\_name | Name of the domain | `string` | n/a | yes |
| ebs\_enabled | Whether EBS volumes are attached to data nodes in the domain | `bool` | `true` | no |
| ebs\_options | EBS related options, may be required based on chosen instance size | `map` | `{}` | no |
| ebs\_options\_iops | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type | `number` | `0` | no |
| ebs\_options\_volume\_size | The size of EBS volumes attached to data nodes (in GB). Required if ebs\_enabled is set to true | `number` | `10` | no |
| ebs\_options\_volume\_type | The type of EBS volumes attached to data nodes | `string` | `"gp2"` | no |
| elasticsearch\_version | The version of Elasticsearch to deploy. | `string` | `"7.1"` | no |
| encrypt\_at\_rest | Encrypt at rest options. Only available for certain instance types | `map` | `{}` | no |
| encrypt\_at\_rest\_enabled | Whether to enable encryption at rest | `bool` | `true` | no |
| encrypt\_at\_rest\_kms\_key\_id | The KMS key id to encrypt the Elasticsearch domain with. If not specified then it defaults to using the aws/es service KMS key | `string` | `"alias/aws/es"` | no |
| log\_publishing\_options | Options for publishing slow logs to CloudWatch Logs | `map` | `{}` | no |
| log\_publishing\_options\_cloudwatch\_log\_group\_arn | iARN of the Cloudwatch log group to which log needs to be published | `string` | `""` | no |
| log\_publishing\_options\_enabled | Specifies whether given log publishing option is enabled or not | `bool` | `true` | no |
| log\_publishing\_options\_log\_type | A type of Elasticsearch log. Valid values: INDEX\_SLOW\_LOGS, SEARCH\_SLOW\_LOGS, ES\_APPLICATION\_LOGS | `string` | `"INDEX_SLOW_LOGS"` | no |
| node\_to\_node\_encryption | Node-to-node encryption options | `map` | `{}` | no |
| node\_to\_node\_encryption\_enabled | Whether to enable node-to-node encryption | `bool` | `true` | no |
| snapshot\_options | Snapshot related options | `map` | `{}` | no |
| snapshot\_options\_automated\_snapshot\_start\_hour | Hour during which the service takes an automated daily snapshot of the indices in the domain | `number` | `0` | no |
| tags | A mapping of tags to assign to the resource | `map` | `{}` | no |
| timeouts | Timeouts map. | `map` | `{}` | no |
| timeouts\_update | How long to wait for updates. | `string` | n/a | no |
| vpc\_options | VPC related options, see below. Adding or removing this configuration forces a new resource | `map` | `{}` | no |
| vpc\_options\_security\_group\_ids | List of VPC Security Group IDs to be applied to the Elasticsearch domain endpoints. If omitted, the default Security Group for the VPC will be used | `list` | `[]` | no |
| vpc\_options\_subnet\_ids | List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the domain |
| domain\_id | Unique identifier for the domain |
| endpoint | Domain-specific endpoint used to submit index, search, and data upload requests |
| kibana\_endpoint | Domain-specific endpoint for kibana without https scheme |
| vpc\_options\_availability\_zones | If the domain was created inside a VPC, the names of the availability zones the configured subnet\_ids were created inside |
| vpc\_options\_vpc\_id | If the domain was created inside a VPC, the ID of the VPC |
