output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_arn
}


output "log_group_name" {
  description = "Application CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.name
}

output "unhealthy_targets_alarm_name" {
  description = "Alarm monitoring healthy ALB targets"
  value       = aws_cloudwatch_metric_alarm.unhealthy_targets.alarm_name
}

output "target_5xx_alarm_name" {
  description = "Alarm monitoring target HTTP 5xx errors"
  value       = aws_cloudwatch_metric_alarm.target_5xx.alarm_name
}