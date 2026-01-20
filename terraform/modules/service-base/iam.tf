resource "aws_iam_role" "document_processor_role" {
  name = "${var.service_name}-${var.environment}-role"
  assume_role_policy = jsondecode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "${data.aws_iam_openid_connect_provider.oidc_provider_url.arn}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_issuer}:sub" = "system:serviceaccount:${var.namespace}:${var.service_name}",
            "${local.oidc_issuer}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "service_role_policy" {
  name = "${var.service_name}-${var.environment}-policy"
  role = aws_iam_role.document_processor_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = "arn:aws:s3:::documentprocessor"
        condition = {
          StringLike = {
            "s3:prefix" = "${local.s3_bucket_prefix}/*"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::documentprocessor/${local.s3_bucket_prefix}/*"

      },
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = "arn:aws:sqs:${var.region}:${var.account_id}:documentprocessor-queue"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/eks/${var.environment}/*"
      }
    ]
  })

}

data "aws_eks_cluster" "cluster" {
  name = "staging-cluster"
}

data "aws_iam_openid_connect_provider" "oidc_provider_url" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

locals {
  s3_bucket_prefix = "raw-files"
  oidc_issuer = var.eks_oidc_issuer
}