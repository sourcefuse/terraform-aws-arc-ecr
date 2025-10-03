module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = "poc"
  project     = "arc"

  extra_tags = {
    RepoName = "terraform-aws-arc-ecr"
  }
}

module "ecr" {
  source = "../../"

  repositories = {
    "immutable-app" = {
      force_delete         = false
      image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
      encryption_type      = "AES256"
      scan_on_push         = true
      repository_tags = {
        Application = "immutable-app"
        Criticality = "high"
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
    "mutable-app" = {
      force_delete         = true
      image_tag_mutability = "MUTABLE"
      encryption_type      = "AES256"
      scan_on_push         = true
      repository_tags = {
        Application = "mutable-app"
        Criticality = "low"
      }
    }
  }

  tags = module.tags.tags
}
