variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to the ALB"
  type        = string
}
