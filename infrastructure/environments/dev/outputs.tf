output "aws_account_id" {
  description = "AWS account used by the development environment"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS deployment region"
  value       = var.aws_region
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}



output "standalone_instance_id" {
  description = "Temporary EC2 validation instance ID"
  value       = module.compute.standalone_instance_id
}

output "standalone_private_ip" {
  description = "Private IP of temporary EC2 validation instance"
  value       = module.compute.standalone_private_ip
}

output "launch_template_id" {
  description = "Application launch template ID"
  value       = module.compute.launch_template_id
}

output "application_ami_id" {
  description = "Amazon Linux 2023 AMI used by application instances"
  value       = module.compute.ami_id
}


output "alb_dns_name" {
  description = "Public DNS name of CloudMovie Challenge"
  value       = module.alb.dns_name
}

output "autoscaling_group_name" {
  description = "Application Auto Scaling Group"
  value       = module.compute.autoscaling_group_name
}

output "dynamodb_table_name" {
  description = "Leaderboard DynamoDB table"
  value       = module.database.table_name
}

output "tmdb_secret_arn" {
  value = module.secrets.secret_arn
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}


