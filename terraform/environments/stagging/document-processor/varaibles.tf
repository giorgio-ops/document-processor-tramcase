variable "region" {
  type        = string
  description = "AWS Region where the resources will be created"

}
variable "account_id" {
  type        = string
  description = "AWS Accout where the resources will be created"
}
variable "environment" {
  type        = string
  description = "Environment where the resources will be created"

}
variable "service_name" {
  type        = string
  description = "Service name to identify the resources"
  default     = "document-processor"
}

variable "s3_versioning_enabled" {
  type        = bool
  description = "Enable S3 versioning"
  default     = true
}
variable "sqs_visibility_timeout" {
  type        = number
  description = "SQS visibility timeout in seconds"
}
variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs"
}
variable "namespace" {
  type        = string
  description = "Kubernetes namespace where the service account is located"
}