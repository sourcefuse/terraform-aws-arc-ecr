# Terraform AWS ARC ECR Module Usage Guide

## Introduction

### Purpose of the Document

This document provides guidelines and instructions for users looking to implement the Terraform AWS ECR (Elastic Container Registry) module for comprehensive container registry management.

### Module Overview

The Terraform AWS ARC ECR module provides a secure and modular foundation for deploying ECR repositories, registry configurations, and related resources on AWS. It supports all ECR resource types with conditional creation, security best practices, and production-ready configurations.

### Prerequisites

Before using this module, ensure you have the following:

- AWS credentials configured.
- Terraform installed (>= 1.3).
- AWS Provider (>= 5.0).
- A working knowledge of AWS ECR, container registries, and Terraform concepts.

## Getting Started

### Module Source

To use the module in your Terraform configuration, include the following source block:

```hcl
module "arc-ecr" {
  source  = "sourcefuse/arc-ecr/aws"
  version = "0.0.1"

  # Basic repository configuration
  repositories = {
    "my-app" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push        = true
      encryption_type     = "AES256"
    }
  }

  # Global tags
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

Refer to the [Terraform Registry](https://registry.terraform.io/modules/sourcefuse/arc-ecr/aws/latest) for the latest version.

### Integration with Existing Terraform Configurations

Integrate the module with your existing Terraform mono repo configuration, follow the steps below:

- Create a new folder in terraform/ named ecr.
- Create the required files, see the examples to base off of.
- Configure with your backend:
   - Create the environment backend configuration file: config.<environment>.hcl
   - region: Where the backend resides
   - key: ecr/terraform.tfstate
   - bucket: Bucket name where the terraform state will reside
   - dynamodb_table: Lock table so there are not duplicate tfplans in the mix
   - encrypt: Encrypt all traffic to and from the backend

### Required AWS Permissions

Ensure that the AWS credentials used to execute Terraform have the necessary permissions to create, list and modify:

- ECR repositories and repository policies
- ECR registry policies and scanning configurations
- ECR replication configurations
- ECR pull-through cache rules
- ECR repository creation templates
- ECR account settings
- KMS keys (if using KMS encryption)
- IAM roles (if using custom roles for pull-through cache)

## Module Configuration

### Input Variables

For a list of input variables, see the README [Inputs](https://github.com/sourcefuse/terraform-aws-arc-ecr#inputs) section.

Key variables include:
- `repositories` - Map of ECR repositories to create
- `enable_registry_scanning` - Enable enhanced registry scanning
- `enable_replication` - Enable cross-region/account replication
- `pull_through_cache_rules` - Configure pull-through cache rules
- `repository_creation_template` - Set organization-wide defaults

### Output Values

For a list of outputs, see the README [Outputs](https://github.com/sourcefuse/terraform-aws-arc-ecr#outputs) section.

Key outputs include:
- `repository_urls` - ECR repository URLs for docker push/pull
- `repository_arns` - Repository ARNs for IAM policies
- `registry_id` - Registry ID for cross-account access

## Module Usage

### Basic Usage

For basic usage, see the [basic-repository example](https://github.com/sourcefuse/terraform-aws-arc-ecr/tree/main/examples/basic-repository) folder.

This example will create:

- A single ECR repository with AES256 encryption
- Image scanning enabled on push
- Mutable image tags
- Basic tagging structure

### Advanced Usage Examples

#### Comprehensive Repository Configuration
See [comprehensive-repository example](https://github.com/sourcefuse/terraform-aws-arc-ecr/tree/main/examples/comprehensive-repository) for:
- Multiple repositories with different configurations
- KMS encryption with custom keys
- Image tag mutability exclusion filters
- Per-repository custom tags

#### Registry Scanning Configuration
See [registry-scanning example](https://github.com/sourcefuse/terraform-aws-arc-ecr/tree/main/examples/registry-scanning) for:
- Enhanced registry scanning with Inspector
- Custom scanning rules and frequencies
- Repository-specific scanning filters

#### Cross-Region Replication
See [replication example](https://github.com/sourcefuse/terraform-aws-arc-ecr/tree/main/examplesexamples/replication) for:
- Multi-region repository replication
- Cross-account replication setup
- Repository filtering for selective replication

#### Pull-Through Cache Rules
See [pull-through-cache example](https://github.com/sourcefuse/terraform-aws-arc-ecr/tree/main/examplespull-through-cache) for:
- Docker Hub image caching
- ECR Public registry caching
- Cross-account ECR private registry caching

### Tips and Recommendations

- The module focuses on provisioning ECR resources with security best practices. The convention-based approach enables downstream services to easily integrate with the container registry. Adjust the configuration parameters as needed for your specific use case.
- Use KMS encryption for sensitive workloads
- Enable image scanning for security compliance
- Implement lifecycle policies to manage storage costs
- Use immutable tags for production repositories
- Configure replication for disaster recovery scenarios

## Troubleshooting

### Common Issues

1. **KMS Key Access**: Ensure the Terraform execution role has access to KMS keys when using KMS encryption
2. **Cross-Account Replication**: Verify IAM permissions and registry policies for cross-account scenarios
3. **Pull-Through Cache**: Check upstream registry connectivity and authentication credentials

### Reporting Issues

If you encounter a bug or issue, please report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-ecr).

## Security Considerations

### ECR Security Best Practices

Understand the security considerations related to ECR on AWS when using this module:

- Use KMS encryption for sensitive container images
- Enable image scanning to detect vulnerabilities
- Implement least-privilege IAM policies
- Use immutable tags for production images
- Configure repository policies for cross-account access

### Best Practices for AWS ECR

Follow best practices to ensure secure ECR configurations:

- [AWS ECR Security Best Practices](https://docs.aws.amazon.com/AmazonECR/latest/userguide/security.html)
- [Container Image Security](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html)
- [ECR Repository Policies](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policies.html)

## Contributing and Community Support

### Contributing Guidelines

Contribute to the module by following the guidelines outlined in the [CONTRIBUTING.md](https://github.com/sourcefuse/terraform-aws-arc-ecr/blob/main/CONTRIBUTING.md) file.

### Reporting Bugs and Issues

If you find a bug or issue, report it on the [GitHub repository](https://github.com/sourcefuse/terraform-aws-arc-ecr).

## License

### License Information

This module is licensed under the Apache 2.0 license. Refer to the [LICENSE](https://github.com/sourcefuse/terraform-aws-arc-ecr/blob/main/LICENSE) file for more details.

### Open Source Contribution

Contribute to open source by using and enhancing this module. Your contributions are welcome!
