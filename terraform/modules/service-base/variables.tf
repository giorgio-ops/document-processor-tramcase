variable "region" {
  type        = string
  description = "Region where the IaC is deployed"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID where the IaC is deployed"
}
variable "environment" {
  type        = string
  description = "Environment where the IaC is deployed"
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
variable "tags" {
  type = map(string)
}

variable "eks_cluster_arn" {
  type        = string
  description = "EKS Cluster ARN"
}
variable "eks_oidc_issuer" {
  type        = string
  description = "EKS OIDC Issuer URL"
}