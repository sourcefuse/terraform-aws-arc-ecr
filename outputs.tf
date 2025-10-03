output "repository_arns" {
  description = "ARNs of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.arn }
}

output "repository_urls" {
  description = "URLs of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}

output "repository_registry_ids" {
  description = "Registry IDs of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.registry_id }
}

output "repository_names" {
  description = "Names of the ECR repositories"
  value       = { for k, v in aws_ecr_repository.this : k => v.name }
}

output "registry_id" {
  description = "Registry ID"
  value       = try(aws_ecr_repository.this[keys(aws_ecr_repository.this)[0]].registry_id, null)
}

output "replication_configuration_registry_id" {
  description = "Registry ID from replication configuration"
  value       = try(aws_ecr_replication_configuration.this[0].registry_id, null)
}

output "pull_through_cache_rule_registry_ids" {
  description = "Registry IDs from pull through cache rules"
  value       = { for k, v in aws_ecr_pull_through_cache_rule.this : k => v.registry_id }
}

output "repository_creation_template_registry_id" {
  description = "Registry ID from repository creation template"
  value       = try(aws_ecr_repository_creation_template.this[0].registry_id, null)
}
