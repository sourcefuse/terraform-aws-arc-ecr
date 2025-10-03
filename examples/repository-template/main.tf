#################################################################
# Module: Tags
#################################################################
module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = "poc"
  project     = "arc"

  extra_tags = {
    RepoName = "terraform-aws-arc-ecr"
  }
}


data "aws_caller_identity" "current" {}

################################################################################
# Locals: Templates - Purpose: Define lifecycle and repository policies for ECR
################################################################################
locals {
  template_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  template_repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAccountAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

#################################################################
# Module: ECR
#################################################################
module "ecr" {
  source = "../../"

  repository_creation_template = {
    prefix               = "myorg/"
    applied_for          = ["REPLICATION", "PULL_THROUGH_CACHE"]
    custom_role_arn      = aws_iam_role.ecr_template_role.arn
    description          = "Template for organization repositories with comprehensive settings"
    encryption_type      = "AES256"
    image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
    lifecycle_policy     = local.template_lifecycle_policy
    repository_policy    = local.template_repository_policy
    resource_tags = {
      CreatedBy   = "template"
      Environment = "production"
      Team        = "platform"
    }
    image_tag_mutability_exclusion_filters = [
      {
        filter      = "latest"
        filter_type = "WILDCARD"
      },
      {
        filter      = "dev-*"
        filter_type = "WILDCARD"
      }
    ]
  }

  tags = module.tags.tags
}


#################################################################
# IAM Role for ECR Template
#################################################################
resource "aws_iam_role" "ecr_template_role" {
  name = "ecr-template-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#################################################################
# IAM Policy for ECR Template Role
#################################################################
resource "aws_iam_policy" "ecr_template_policy" {
  name        = "ECRRepositoryTemplatePolicy"
  description = "Custom policy for ECR repository creation template role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:CreateRepository",
          "ecr:PutLifecyclePolicy",
          "ecr:PutReplicationConfiguration",
          "ecr:PutImageTagMutability",
          "ecr:PutImageScanningConfiguration",
          "ecr:SetRepositoryPolicy",
          "ecr:TagResource",
          "ecr:UntagResource"
        ]
        Resource = "*"
      }
    ]
  })
}

#################################################################
# IAM Role Policy Attachment
#################################################################
resource "aws_iam_role_policy_attachment" "ecr_template_role_attach" {
  role       = aws_iam_role.ecr_template_role.name
  policy_arn = aws_iam_policy.ecr_template_policy.arn
}
