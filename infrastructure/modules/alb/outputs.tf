output "target_group_arn" {
  description = "ARN of the application target group"
  value       = aws_lb_target_group.app.arn
}

output "dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.app.dns_name
}

output "arn" {
  description = "ARN of the application load balancer"
  value       = aws_lb.app.arn
}


output "load_balancer_arn_suffix" {
  description = "ARN suffix used as the CloudWatch LoadBalancer dimension"
  value       = aws_lb.app.arn_suffix
}

output "target_group_arn_suffix" {
  description = "ARN suffix used as the CloudWatch TargetGroup dimension"
  value       = aws_lb_target_group.app.arn_suffix
}

