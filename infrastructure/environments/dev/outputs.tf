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
