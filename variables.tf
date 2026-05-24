variable "environment" {
  type        = string
  description = "Deployment environment. Must be one of: dev, staging, production."

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment must be one of: dev, staging, production."
  }
}

variable "project_name" {
  type        = string
  description = "Project name used in resource names and tags. Lowercase, alphanumeric and hyphens only."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,28}[a-z0-9]$", var.project_name))
    error_message = "project_name must be 3-30 characters, lowercase alphanumeric and hyphens, start with a letter."
  }
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy into."
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC. Must be between /16 and /24."

  validation {
    condition = can(cidrhost(var.vpc_cidr, 0)) && (
      tonumber(split("/", var.vpc_cidr)[1]) >= 16 &&
      tonumber(split("/", var.vpc_cidr)[1]) <= 24
    )
    error_message = "vpc_cidr must be a valid CIDR block with a prefix length between /16 and /24."
  }
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Create a NAT gateway for private subnet egress. Disable for dev to save cost."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags applied to all resources."
}
