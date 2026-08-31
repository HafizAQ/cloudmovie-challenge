output "launch_template_id" {
  description = "ID of the application launch template"
  value       = aws_launch_template.app.id
}

output "standalone_instance_id" {
  description = "ID of temporary standalone validation instance"
  value       = try(aws_instance.standalone[0].id, null)
}

output "standalone_private_ip" {
  description = "Private IP address of standalone validation instance"
  value       = try(aws_instance.standalone[0].private_ip, null)
}

output "ami_id" {
  description = "Amazon Linux 2023 AMI selected through SSM"
  value       = nonsensitive(data.aws_ssm_parameter.amazon_linux.value)
}
