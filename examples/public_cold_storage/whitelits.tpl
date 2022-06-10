{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${region}:${account}:domain/${domain_name}/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ${whitelist}
        }
      }
    }
  ]
}
