output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "security_group_id" {
  description = "ID of the baseline security group"
  value       = aws_security_group.baseline.id
}

output "iam_role_arn" {
  description = "ARN of the service IAM role"
  value       = aws_iam_role.service.arn
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.service.name
}

output "state_bucket_name" {
  description = "Name of the S3 state bucket"
  value       = aws_s3_bucket.state.bucket
}
