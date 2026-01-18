resource "aws_iam_role" "document_processor_role" {
    name               = "${var.service_name}-${var.environment}-role"
    assume_role_policy = jsondecode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Federated = "arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/EXAMPLE"
                },
                Action = "sts:AssumeRoleWithWebIdentity",
                Condition = {
                    StringEquals = {
                        "oidc.eks.${var.region}.amazonaws.com/id/EXAMPLE:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}",
                        "oidc.eks.${var.region}.amazonaws.com/id/EXAMPLE:aud" = "sts.amazonaws.com"
                    }
                }
            }
        ]
    })
    
    tags = var.tags
}

resource "aws_iam_role_policy" "service_role_policy" {  
    name = "${var.service_name}-${var.environment}-policy"
    role = aws_iam_role.service_role.id

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

locals {
  s3_bucket_prefix="raw-files"
}