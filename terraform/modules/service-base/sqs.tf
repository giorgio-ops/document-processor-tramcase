resource "aws_sqs_queue" "document_processor_queue" {
  name                       = "${var.service_name}-${var.environment}-queue"
  visibility_timeout_seconds = 300    # 5 minutes
  message_retention_seconds  = 604800 # 7 days
  tags                       = var.tags
}

resource "aws_sqs_queue" "document_processor_dead_letter_queue" {
  name = "${var.service_name}-${var.environment}-dead-letter-queue"
  redrive_allow_policy = jsondecode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.document_processor_queue.arn]
  })
  tags = var.tags

}

resource "aws_sqs_queue_redrive_policy" "document_processor_queue_redrive_policy" {
  queue_url = aws_sqs_queue.document_processor_queue.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.document_processor_dead_letter_queue.arn,
    maxReceiveCount     = 3
  })

}