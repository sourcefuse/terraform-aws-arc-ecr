# Basic ECR Repository Example

This example demonstrates how to create a basic ECR repository with encryption and image scanning enabled.

## What This Example Creates

- A single ECR repository named "my-app"
- AES256 encryption enabled
- Image scanning on push enabled
- Mutable image tags

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- `repository_url` - The URL of the created ECR repository
- `repository_arn` - The ARN of the created ECR repository

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