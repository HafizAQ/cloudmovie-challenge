variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, staging, or prod"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix for CloudWatch metrics"
  type        = string
}
