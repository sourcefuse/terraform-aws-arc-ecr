# ECR with Lifecycle Policy Example

This example demonstrates how to create an ECR repository with a lifecycle policy to automatically clean up old images.

## What This Example Creates

- ECR repository with lifecycle policy
- Policy keeps last 10 tagged images (with "v" prefix)
- Policy deletes untagged images older than 1 day

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Lifecycle Policy Rules

1. **Tagged Images**: Keep last 10 images with tags starting with "v"
2. **Untagged Images**: Delete images older than 1 day

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | ARN of the ECR repository |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | URL of the ECR repository |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->