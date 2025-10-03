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
    "my-app" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
    }
  }

  tags = module.tags.tags
}
