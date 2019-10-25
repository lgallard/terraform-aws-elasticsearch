data "aws_iam_policy_document" "allow_access_to_the_domain_from_specific_ips" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "es:*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.es_ips
    }

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain_name}/*",
    ]
  }
}

