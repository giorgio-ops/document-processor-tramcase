output "iam_role_arn" {
  description = "IAM Role ARN for Kubernetes Service Account"
  value       = aws_iam_role.document_processor_role.arn
}
output "s3_bucket_name" {
  description = "S3 Bucket Name for Document Processor"
  value       = aws_s3_bucket.document_processor_bucket.id
}
output "s3_bucket_arn" {
  description = "S3 Bucket ARN for Document Processor"
  value       = aws_s3_bucket.document_processor_bucket.arn
}
output "sqs_queue_url" {
  description = "SQS Queue URL for Document Processor"
  value       = aws_sqs_queue.document_processor_queue.url
}
output "sqs_queue_arn" {
  description = "SQS Queue ARN for Document Processor"
  value       = aws_sqs_queue.document_processor_queue.arn
}
output "sqs_dlq_url" {
  description = "SQS Dead Letter Queue URL for Document Processor"
  value       = aws_sqs_queue.document_processor_dead_letter_queue.url
}
output "log_group_name" {
  description = "CloudWatch Log Group Name for Document Processor"
  value       = aws_cloudwatch_log_group.document_processor_log_group.name
}