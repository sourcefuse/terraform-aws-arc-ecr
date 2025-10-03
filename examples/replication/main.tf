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

#################################################################
# Module: ECR
#################################################################
module "ecr" {
  source = "../../"

  repositories = {
    "replicated-app" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
    }
  }

  enable_replication = true
  replication_configuration = {
    rules = [
      {
        destinations = [
          {
            region      = "us-east-2"
            registry_id = data.aws_caller_identity.current.account_id
          }
        ]
        repository_filters = [
          {
            filter      = "replicated-app"
            filter_type = "PREFIX_MATCH"
          }
        ]
      }
    ]
  }

  tags = module.tags.tags
}
