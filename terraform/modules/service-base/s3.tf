resource "aws_s3_bucket" "document_processor_bucket" {
  bucket = "${var.service_name}-${var.environment}-bucket"

  tags = var.tags
}
resource "aws_s3_bucket_versioning" "document_processor_bucket_versioning" {
  bucket = aws_s3_bucket.document_processor_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

}
resource "aws_s3_bucket_server_side_encryption_configuration" "document_processor_bucket_encryption" {
  bucket = aws_s3_bucket.document_processor_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "document_processor_bucket_lifecycle" {
  bucket = aws_s3_bucket.document_processor_bucket.id

  rule {
    id     = "Move old files to infrequent access and expire them"
    status = "Enabled"
    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
    ## If required to limit the rule to the IAM S3 prefix
    # filter {
    # prefix = local.s3_bucket_prefix + "/"
    # }
  }

}
resource "aws_s3_bucket_public_access_block" "document_processor_bucket_lifecycle_public_access_block" {
  bucket = aws_s3_bucket.document_processor_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

