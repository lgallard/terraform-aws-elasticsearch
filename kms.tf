data "aws_kms_key" "aws_es" {
  key_id = var.encrypt_at_rest_kms_key_id
}
