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

module "ecr" {
  source = "../../"

  pull_through_cache_rules = {
    "dockerhub" = {
      ecr_repository_prefix      = "docker-hub"
      upstream_registry_url      = "registry-1.docker.io"
      credential_arn             = aws_secretsmanager_secret.dockerhub.arn
      custom_role_arn            = null
      upstream_repository_prefix = null
    }
    "public-ecr" = {
      ecr_repository_prefix      = "ecr-public"
      upstream_registry_url      = "public.ecr.aws"
      credential_arn             = null
      custom_role_arn            = null
      upstream_repository_prefix = "ROOT"
    }
    # "cross-account-ecr" = {
    #   ecr_repository_prefix      = "cross-account"
    #   upstream_registry_url      = "123456789012.dkr.ecr.us-west-2.amazonaws.com"
    #   credential_arn             = "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:ecr-credentials"
    #   custom_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ECRPullThroughCacheRole"
    #   upstream_repository_prefix = "myorg"
    # }
  }

  tags = module.tags.tags
}


resource "random_string" "dockerhub_username" {
  length  = 12
  upper   = true
  lower   = true
  numeric  = true
  special = false
}

resource "random_password" "dockerhub_password" {
  length           = 20
  special          = true
  override_special = "!@#$%^&*()-_=+"
}


resource "aws_secretsmanager_secret" "dockerhub" {
  name = "ecr-pullthroughcache/dockerhub"
}

resource "aws_secretsmanager_secret_version" "dockerhub" {
  secret_id     = aws_secretsmanager_secret.dockerhub.id
  secret_string = jsonencode({
    username = random_string.dockerhub_username.result
    password = random_password.dockerhub_password.result  
  })
}

