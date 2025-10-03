output "repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_urls["my-app-with-lifecycle"]
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arns["my-app-with-lifecycle"]
}
