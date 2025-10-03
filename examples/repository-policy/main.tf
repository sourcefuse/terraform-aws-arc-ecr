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

locals {
  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountAccess"
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

module "ecr" {
  source = "../../"

  repositories = {
    "shared-app" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
      repository_policy    = local.repository_policy
    }
  }

  tags = module.tags.tags
}
