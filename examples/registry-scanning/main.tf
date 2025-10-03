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
    "scanned-app" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
    }
  }

  enable_registry_scanning = true
  registry_scanning_configuration = {
    scan_type = "ENHANCED"
    rules = [
      {
        scan_frequency = "SCAN_ON_PUSH"
        repository_filters = [
          {
            filter      = "scanned-app"
            filter_type = "WILDCARD"
          }
        ]
      }
    ]
  }

  tags = module.tags.tags
}
