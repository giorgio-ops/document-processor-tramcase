variable "service_name" {
  type = string
  description = "Service name to identify the resources"
  default = "document-processor"
}
variable "environment" {
  type = string
  description = "Environment where the IaC is deployed"
}
variable "region" {
    type = string
    description = "Region where the IaC is deployed"
  
}
variable "account_id" {
    type = string
    description = "AWS Account ID where the IaC is deployed"
}
variable "namespace" {
    type = string
    description = "Kubernetes namespace where the service account is located"
}
variable "service_account_name" {
    type = string
    description = "Kubernetes service account name associated with the IAM role"
}
variable "tags" {
  type = map(string)
  default = {
    "owner" = "tramcase"
    "created_by" = "giorgio-ops"
    "managed_by" = "terraform"
    "cost_center" = "document-processor"
  }
}