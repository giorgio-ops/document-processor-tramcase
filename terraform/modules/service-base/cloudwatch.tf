resource "aws_cloudwatch_log_group" "document_processor_log_group" {
  name              = "/aws/eks/${var.environment}/${var.service_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = ""
  tags              = var.tags

}

## Already using AWS KMS managed key for CloudWatch Logs