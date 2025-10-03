output "repository_urls" {
  description = "URLs of all ECR repositories"
  value       = module.ecr.repository_urls
}

output "repository_arns" {
  description = "ARNs of all ECR repositories"
  value       = module.ecr.repository_arns
}

output "immutable_app_url" {
  description = "URL of the immutable app repository"
  value       = module.ecr.repository_urls["immutable-app"]
}

output "mutable_app_url" {
  description = "URL of the mutable app repository"
  value       = module.ecr.repository_urls["mutable-app"]
}
