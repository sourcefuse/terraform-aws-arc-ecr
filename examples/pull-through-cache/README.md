# ECR Pull-Through Cache Example

This example demonstrates how to set up comprehensive ECR pull-through cache rules with all available arguments for different registry types.

## What This Example Creates

### Docker Hub Cache Rule
- **Prefix**: docker-hub/
- **Upstream**: registry-1.docker.io
- **Authentication**: None (public registry)
- **Repository Prefix**: None (matches all repositories)

### ECR Public Cache Rule
- **Prefix**: ecr-public/
- **Upstream**: public.ecr.aws
- **Authentication**: None (public registry)
- **Repository Prefix**: ROOT (explicit all repositories)

### Cross-Account ECR Cache Rule
- **Prefix**: cross-account/
- **Upstream**: Private ECR in another account
- **Authentication**: Secrets Manager credential
- **Custom Role**: IAM role for cross-account access
- **Repository Prefix**: myorg (specific upstream prefix)

## Features Demonstrated

- ✅ All pull through cache rule arguments
- ✅ Public registry caching (Docker Hub, ECR Public)
- ✅ Cross-account ECR private registry caching
- ✅ Credential-based authentication
- ✅ Custom IAM roles for cross-account access
- ✅ Upstream repository prefix filtering

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cache Rule Behavior

### Docker Hub Usage
```bash
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/docker-hub/library/nginx:latest
```

### ECR Public Usage
```bash
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/ecr-public/nginx/nginx:latest
```

### Cross-Account ECR Usage
```bash
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/cross-account/myorg/my-app:latest
```

## Prerequisites for Cross-Account ECR

1. **Secrets Manager Secret**: Store upstream registry credentials
2. **IAM Role**: Cross-account access permissions
3. **Upstream Registry Policy**: Allow pull access from this account

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
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.dockerhub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.dockerhub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.dockerhub_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.dockerhub_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dockerhub_registry_id"></a> [dockerhub\_registry\_id](#output\_dockerhub\_registry\_id) | Registry ID for Docker Hub pull through cache rule |
| <a name="output_public_ecr_registry_id"></a> [public\_ecr\_registry\_id](#output\_public\_ecr\_registry\_id) | Registry ID for ECR Public pull through cache rule |
| <a name="output_pull_through_cache_registry_ids"></a> [pull\_through\_cache\_registry\_ids](#output\_pull\_through\_cache\_registry\_ids) | Registry IDs of all pull through cache rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->