#########################################
## ECR Account Setting
#########################################
resource "aws_ecr_account_setting" "this" {
  count = var.account_setting_name != null ? 1 : 0

  name  = var.account_setting_name
  value = var.account_setting_value
}

#########################################
## ECR Repositories
#########################################
resource "aws_ecr_repository" "this" {
  for_each = var.repositories

  name                 = each.key
  force_delete         = each.value.force_delete
  image_tag_mutability = each.value.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  encryption_configuration {
    encryption_type = each.value.encryption_type
    kms_key         = each.value.kms_key
  }

  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = each.value.image_tag_mutability_exclusion_filters
    content {
      filter      = image_tag_mutability_exclusion_filter.value.filter
      filter_type = image_tag_mutability_exclusion_filter.value.filter_type
    }
  }

  tags = var.tags
}

#########################################
## ECR Lifecycle Policies
#########################################
resource "aws_ecr_lifecycle_policy" "this" {
  for_each = {
    for k, v in var.repositories : k => v
    if v.lifecycle_policy != null
  }

  repository = aws_ecr_repository.this[each.key].name
  policy     = each.value.lifecycle_policy
}

#########################################
## ECR Repository Policies
#########################################
resource "aws_ecr_repository_policy" "this" {
  for_each = {
    for k, v in var.repositories : k => v
    if v.repository_policy != null
  }

  repository = aws_ecr_repository.this[each.key].name
  policy     = each.value.repository_policy
}

#########################################
## ECR Registry Policy
#########################################
resource "aws_ecr_registry_policy" "this" {
  count = var.registry_policy != null ? 1 : 0

  policy = var.registry_policy
}

#########################################
## ECR Registry Scanning Configuration
#########################################
resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.enable_registry_scanning ? 1 : 0

  scan_type = var.registry_scanning_configuration.scan_type

  dynamic "rule" {
    for_each = var.registry_scanning_configuration.rules
    content {
      scan_frequency = rule.value.scan_frequency

      dynamic "repository_filter" {
        for_each = rule.value.repository_filters
        content {
          filter      = repository_filter.value.filter
          filter_type = repository_filter.value.filter_type
        }
      }
    }
  }
}

#########################################
## ECR Replication Configuration
#########################################
resource "aws_ecr_replication_configuration" "this" {
  count = var.enable_replication ? 1 : 0

  dynamic "replication_configuration" {
    for_each = [var.replication_configuration]
    content {
      dynamic "rule" {
        for_each = replication_configuration.value.rules
        content {
          dynamic "destination" {
            for_each = rule.value.destinations
            content {
              region      = destination.value.region
              registry_id = destination.value.registry_id
            }
          }

          dynamic "repository_filter" {
            for_each = rule.value.repository_filters
            content {
              filter      = repository_filter.value.filter
              filter_type = repository_filter.value.filter_type
            }
          }
        }
      }
    }
  }
}

#########################################
# ECR Pull Through Cache Rules
#########################################
resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = var.pull_through_cache_rules

  ecr_repository_prefix      = each.value.ecr_repository_prefix
  upstream_registry_url      = each.value.upstream_registry_url
  credential_arn             = each.value.credential_arn
  custom_role_arn            = each.value.custom_role_arn
  upstream_repository_prefix = each.value.upstream_repository_prefix
}

#########################################
# ECR Repository Creation Template
#########################################
resource "aws_ecr_repository_creation_template" "this" {
  count = var.repository_creation_template != null ? 1 : 0

  prefix               = var.repository_creation_template.prefix
  applied_for          = var.repository_creation_template.applied_for
  custom_role_arn      = var.repository_creation_template.custom_role_arn
  description          = var.repository_creation_template.description
  image_tag_mutability = var.repository_creation_template.image_tag_mutability
  lifecycle_policy     = var.repository_creation_template.lifecycle_policy
  repository_policy    = var.repository_creation_template.repository_policy
  resource_tags        = var.repository_creation_template.resource_tags

  encryption_configuration {
    encryption_type = var.repository_creation_template.encryption_type
    kms_key         = var.repository_creation_template.kms_key
  }

  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = var.repository_creation_template.image_tag_mutability_exclusion_filters
    content {
      filter      = image_tag_mutability_exclusion_filter.value.filter
      filter_type = image_tag_mutability_exclusion_filter.value.filter_type
    }
  }
}
