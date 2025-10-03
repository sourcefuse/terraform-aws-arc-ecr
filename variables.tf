variable "repositories" {
  description = "Map of ECR repositories to create"
  type = map(object({
    force_delete         = optional(bool, false)
    image_tag_mutability = optional(string, "MUTABLE")
    encryption_type      = optional(string, "AES256")
    kms_key              = optional(string)
    scan_on_push         = optional(bool, true)
    lifecycle_policy     = optional(string)
    repository_policy    = optional(string)
    repository_tags      = optional(map(string), {})
    image_tag_mutability_exclusion_filters = optional(list(object({
      filter      = string
      filter_type = string
    })), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for repo in var.repositories : contains(["MUTABLE", "IMMUTABLE", "IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], repo.image_tag_mutability)
    ])
    error_message = "image_tag_mutability must be one of: MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION."
  }

  validation {
    condition = alltrue([
      for repo in var.repositories : contains(["AES256", "KMS"], repo.encryption_type)
    ])
    error_message = "encryption_type must be either AES256 or KMS."
  }

  validation {
    condition = alltrue([
      for repo in var.repositories : alltrue([
        for filter in repo.image_tag_mutability_exclusion_filters : filter.filter_type == "WILDCARD"
      ])
    ])
    error_message = "image_tag_mutability_exclusion_filter filter_type must be WILDCARD."
  }
}

variable "enable_registry_scanning" {
  description = "Enable registry scanning configuration"
  type        = bool
  default     = false
}

variable "registry_scanning_configuration" {
  description = "Registry scanning configuration"
  type = object({
    scan_type = optional(string, "ENHANCED")
    rules = optional(list(object({
      scan_frequency = string
      repository_filters = list(object({
        filter      = string
        filter_type = string
      }))
    })), [])
  })
  default = {
    scan_type = "ENHANCED"
    rules     = []
  }
}

variable "enable_replication" {
  description = "Enable replication configuration"
  type        = bool
  default     = false
}

variable "replication_configuration" {
  description = "Replication configuration for ECR registry"
  type = object({
    rules = list(object({
      destinations = list(object({
        region      = string
        registry_id = string
      }))
      repository_filters = optional(list(object({
        filter      = string
        filter_type = string
      })), [])
    }))
  })
  default = {
    rules = []
  }
}

variable "pull_through_cache_rules" {
  description = "Pull through cache rules"
  type = map(object({
    ecr_repository_prefix      = string
    upstream_registry_url      = string
    credential_arn             = optional(string)
    custom_role_arn            = optional(string)
    upstream_repository_prefix = optional(string)
  }))
  default = {}
}

variable "registry_policy" {
  description = "Registry policy JSON"
  type        = string
  default     = null
}

variable "repository_creation_template" {
  description = "Repository creation template configuration"
  type = object({
    prefix               = string
    applied_for          = list(string)
    custom_role_arn      = optional(string)
    description          = optional(string)
    encryption_type      = optional(string, "AES256")
    kms_key              = optional(string)
    image_tag_mutability = optional(string, "MUTABLE")
    lifecycle_policy     = optional(string)
    repository_policy    = optional(string)
    resource_tags        = optional(map(string), {})
    image_tag_mutability_exclusion_filters = optional(list(object({
      filter      = string
      filter_type = string
    })), [])
  })
  default = null

  validation {
    condition = var.repository_creation_template == null || alltrue([
      for applied in var.repository_creation_template.applied_for : contains(["PULL_THROUGH_CACHE", "REPLICATION"], applied)
    ])
    error_message = "applied_for must contain one or more of: PULL_THROUGH_CACHE, REPLICATION."
  }

  validation {
    condition     = var.repository_creation_template == null || contains(["MUTABLE", "IMMUTABLE", "IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], var.repository_creation_template.image_tag_mutability)
    error_message = "image_tag_mutability must be one of: MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION."
  }

  validation {
    condition     = var.repository_creation_template == null || contains(["AES256", "KMS"], var.repository_creation_template.encryption_type)
    error_message = "encryption_type must be either AES256 or KMS."
  }

  validation {
    condition = var.repository_creation_template == null || alltrue([
      for filter in var.repository_creation_template.image_tag_mutability_exclusion_filters : filter.filter_type == "WILDCARD"
    ])
    error_message = "image_tag_mutability_exclusion_filter filter_type must be WILDCARD."
  }
}

variable "account_setting_name" {
  description = "ECR account setting name"
  type        = string
  default     = null
}

variable "account_setting_value" {
  description = "ECR account setting value"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}