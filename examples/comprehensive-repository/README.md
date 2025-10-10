# Comprehensive ECR Repository Example

This example demonstrates all available ECR repository arguments and features.

## What This Example Creates

### Immutable App Repository
- **Name**: immutable-app
- **Tag Mutability**: IMMUTABLE_WITH_EXCLUSION
- **Encryption**: KMS with custom key
- **Force Delete**: Disabled (safe)
- **Exclusion Filters**: Allows "latest" and "dev-*" tags to be mutable
- **Custom Tags**: Application and Criticality tags

### Mutable App Repository  
- **Name**: mutable-app
- **Tag Mutability**: MUTABLE
- **Encryption**: AES256 (default)
- **Force Delete**: Enabled
- **Custom Tags**: Application and Criticality tags

## Features Demonstrated

- All ECR repository arguments
- Mixed tag mutability settings
- Image tag mutability exclusion filters
- Different encryption types (KMS vs AES256)
- Per-repository custom tags
- Force delete configuration
- Image scanning configuration

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Exclusion Filter Behavior

The immutable-app repository uses `IMMUTABLE_WITH_EXCLUSION` which means:
- Most tags are immutable (cannot be overwritten)
- Tags matching "latest" or "dev-*" patterns can be overwritten
- Provides flexibility for development while maintaining production immutability

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
| <a name="output_immutable_app_url"></a> [immutable\_app\_url](#output\_immutable\_app\_url) | URL of the immutable app repository |
| <a name="output_mutable_app_url"></a> [mutable\_app\_url](#output\_mutable\_app\_url) | URL of the mutable app repository |
| <a name="output_repository_arns"></a> [repository\_arns](#output\_repository\_arns) | ARNs of all ECR repositories |
| <a name="output_repository_urls"></a> [repository\_urls](#output\_repository\_urls) | URLs of all ECR repositories |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
