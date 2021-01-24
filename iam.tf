resource "aws_cloudwatch_log_group" "es_cloudwatch_log_group" {
  count             = var.enabled ? 1 : 0
  name              = "${var.domain_name}-log_group"
  tags              = var.tags
  retention_in_days = var.log_publishing_options_retention
}

resource "aws_cloudwatch_log_resource_policy" "es_aws_cloudwatch_log_resource_policy" {
  count       = var.enabled ? 1 : 0
  policy_name = "${var.domain_name}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

# Service-linked role to give Amazon ES permissions to access your VPC
resource "aws_iam_service_linked_role" "es" {
  count            = var.enabled && var.create_service_link_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "Service-linked role to give Amazon ES permissions to access your VPC"
}
