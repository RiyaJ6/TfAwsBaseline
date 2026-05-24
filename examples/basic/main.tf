

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "baseline" {
  source = "github.com/RiyaJ6/TfAwsBaseline"

  environment        = "staging"
  project_name       = "ClusterGuard"
  vpc_cidr           = "10.1.0.0/16"
  enable_nat_gateway = true

  tags = {
    Owner = "platform-team"
    Repo  = "github.com/RiyaJ6/ClusterGuard"
  }
}

# Pass the outputs to whatever needs them — EKS, EC2, etc.
output "vpc_id"            { value = module.baseline.vpc_id }
output "private_subnets"   { value = module.baseline.private_subnet_ids }
output "iam_role_arn"      { value = module.baseline.iam_role_arn }
output "state_bucket"      { value = module.baseline.state_bucket_name }
