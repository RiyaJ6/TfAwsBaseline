# TfAwsBaseline

A reusable Terraform module that provisions a secure opinionated AWS baseline environment.

Used as the infrastructure foundation for [ClusterGuard](https://github.com/RiyaJ6/ClusterGuard).
Built to understand how platform teams manage repeatable, safe infrastructure as code installations
with proper variable validation, environment drift prevention and CI guardrails.

---

## What it provisions

| Resource | Description |
|---|---|
| VPC | Custom CIDR with DNS hostnames enabled |
| Subnets | Public + private subnets across 2 AZs |
| Internet Gateway | For public subnets |
| NAT Gateway | For private subnet egress |
| Security Groups | Baseline ingress/egress rules (locked down by default) |
| S3 Bucket | Remote state storage with versioning + server-side encryption |
| IAM Role | Service role with least-privilege policy for application use |
| IAM Instance Profile | Wraps the role for EC2 / EKS node attachment |

---

## Project structure

```
TfAwsBaseline/
├── main.tf            # resource definitions
├── variables.tf       # all inputs with types, defaults, and validation blocks
├── outputs.tf         # outputs consumed by dependent modules
├── examples/
│   └── basic/
│       ├── main.tf    # example showing module usage
├── .github/
│   └── workflows/
│       └── terraform-plan.yaml   # runs terraform plan on every PR
└── README.md
```

---

## Usage

```hcl
module "baseline" {
  source = "github.com/RiyaJ6/TfAwsBaseline"

  environment    = "staging"
  aws_region     = "us-east-1"
  vpc_cidr       = "10.1.0.0/16"
  project_name   = "ClusterGuard"

  tags = {
    Owner   = "platform-team"
    Project = "ClusterGuard"
  }
}

output "vpc_id" {
  value = module.baseline.vpc_id
}
```

---

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|---|---|
| `environment` | `string` | — | yes | Environment name: `dev`, `staging`, or `production` |
| `aws_region` | `string` | `us-east-1` | no | AWS region |
| `vpc_cidr` | `string` | `10.0.0.0/16` | no | VPC CIDR block (must be /16 to /24) |
| `project_name` | `string` | — | yes | Project name used in resource naming and tags |
| `enable_nat_gateway` | `bool` | `true` | no | Create a NAT gateway for private subnets |
| `tags` | `map(string)` | `{}` | no | Additional tags applied to all resources |

---

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `security_group_id` | ID of the baseline security group |
| `iam_role_arn` | ARN of the service IAM role |
| `state_bucket_name` | Name of the S3 state bucket |

---

## CI — terraform plan on every PR

Every pull request triggers a `terraform plan` in the GitHub Actions workflow.
The plan output is posted as a PR comment. Merges are blocked if `plan` fails.
This prevents environment drift from being introduced unreviewed.

See [`.github/workflows/terraform-plan.yaml`](.github/workflows/terraform-plan.yaml).

---

## Environment drift

The module uses `precondition` blocks on key variables to catch configuration
mistakes before `apply` runs. For example, `vpc_cidr` is validated to ensure
it falls within an acceptable CIDR range, and `environment` is constrained
to known values (`dev`, `staging`, `production`).

In practice for ClusterGuard I caught drift between dev and staging when
a manual change to a security group in dev was not reflected in the Terraform state.
Running `terraform plan` in CI surfaced this as an unexpected diff which prompted
a state refresh rather than letting the drift accumulate silently.

---

## Requirements

| Tool | Version |
|---|---|
| Terraform | >= 1.5 |
| AWS Provider | >= 5.0 |
| AWS CLI | configured with appropriate credentials |

<div align="center">

 **Do not be consumed, be the consumer**
