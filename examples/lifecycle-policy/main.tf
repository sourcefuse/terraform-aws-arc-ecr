module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = "poc"
  project     = "arc"

  extra_tags = {
    RepoName = "terraform-aws-arc-ecr"
  }
}

locals {
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

module "ecr" {
  source = "../../"

  repositories = {
    "my-app-with-lifecycle" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
      lifecycle_policy     = local.lifecycle_policy
    }
  }

  tags = module.tags.tags
}
