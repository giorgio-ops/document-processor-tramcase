
module "service-base" {
  source = "../../../modules/service-base"

  service_name    = var.service_name
  environment     = var.environment
  account_id      = var.account_id
  region          = var.region
  namespace       = "document-processor-namespace"
  eks_cluster_arn = "arn:aws:eks:${var.region}:${var.account_id}:cluster/staging-cluster"
  eks_oidc_issuer = "oidc.eks.${var.region}.amazonaws.com/id/EXAMPLE"

  # Optional
  s3_versioning_enabled  = var.s3_versioning_enabled
  sqs_visibility_timeout = var.sqs_visibility_timeout
  log_retention_days     = var.log_retention_days

  tags = {
    Team       = "platform"
    Project    = "tramcase"
    Managed_by = "terraform"
  }

}