# ECR Repository Creation Template Example

This example demonstrates how to create a comprehensive repository creation template with all available arguments.

## What This Example Creates

- Repository creation template with prefix "myorg/"
- Applied to both replication and pull-through cache scenarios
- KMS encryption with custom key
- Immutable tags with exclusion filters
- Custom lifecycle and repository policies
- Resource tags for template-created repositories

## Template Configuration

### Basic Settings
- **Prefix**: myorg/
- **Applied For**: REPLICATION, PULL_THROUGH_CACHE
- **Description**: Comprehensive template settings
- **Custom Role ARN**: None (uses default)

### Security & Encryption
- **Encryption**: KMS with alias/ecr-template-key
- **Image Tag Mutability**: IMMUTABLE_WITH_EXCLUSION
- **Repository Policy**: Cross-account read access

### Lifecycle Management
- **Lifecycle Policy**: Keep last 5 images
- **Exclusion Filters**: Allow "latest" and "dev-*" tags to be mutable

### Tagging
- **Resource Tags**: Applied to all template-created repositories
  - CreatedBy: template
  - Environment: production
  - Team: platform

## Features Demonstrated

- ✅ All repository creation template arguments
- ✅ KMS encryption configuration
- ✅ Image tag mutability exclusion filters
- ✅ Custom lifecycle policy
- ✅ Repository policy for cross-account access
- ✅ Resource tags for template-created repositories
- ✅ Multiple applied_for scenarios

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Template Behavior

When repositories are created via replication or pull-through cache with names matching "myorg/*":
- They will use KMS encryption with the specified key
- Tags will be immutable except for "latest" and "dev-*" patterns
- Lifecycle policy will automatically clean up old images
- Repository policy will allow cross-account read access
- Resource tags will be automatically applied

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.ecr_template_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecr_template_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_template_role_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_creation_template_registry_id"></a> [repository\_creation\_template\_registry\_id](#output\_repository\_creation\_template\_registry\_id) | Registry ID of the repository creation template |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->