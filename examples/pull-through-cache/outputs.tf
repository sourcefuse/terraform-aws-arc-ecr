output "pull_through_cache_registry_ids" {
  description = "Registry IDs of all pull through cache rules"
  value       = module.ecr.pull_through_cache_rule_registry_ids
}

output "dockerhub_registry_id" {
  description = "Registry ID for Docker Hub pull through cache rule"
  value       = module.ecr.pull_through_cache_rule_registry_ids["dockerhub"]
}

output "public_ecr_registry_id" {
  description = "Registry ID for ECR Public pull through cache rule"
  value       = module.ecr.pull_through_cache_rule_registry_ids["public-ecr"]
}

# output "cross_account_registry_id" {
#   description = "Registry ID for cross-account ECR pull through cache rule"
#   value       = module.ecr.pull_through_cache_rule_registry_ids["cross-account-ecr"]
# }
