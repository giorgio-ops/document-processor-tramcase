output "iam_role_arn" { 
    value = aws_iam_role.document_processor_role.arn
}
output "s3_bucket_name" { 
    value = aws_s3_bucket.document_processor_bucket.id
}
output "s3_bucket_arn" { 
    value = aws_s3_bucket.document_processor_bucket.arn
}
output "sqs_queue_url" { 
    value = aws_sqs_queue.document_processor_queue.url
}
output "sqs_queue_arn" { 
    value = aws_sqs_queue.document_processor_queue.arn
}
output "sqs_dlq_url" { 
    value = aws_sqs_queue.document_processor_dead_letter_queue.url
}
output "log_group_name" { 
    value = aws_cloudwatch_log_group.document_processor_log_group.name
}