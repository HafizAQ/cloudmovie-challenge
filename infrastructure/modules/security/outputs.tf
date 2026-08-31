output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Application EC2 security group ID"
  value       = aws_security_group.app.id
}


output "ec2_role_name" {
  value = aws_iam_role.ec2.name
}

output "instance_profile_name" {
  description = "EC2 IAM instance profile name"
  value       = aws_iam_instance_profile.ec2.name
}
