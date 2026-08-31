variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "ec2_role_name" {
  description = "IAM role used by application EC2 instances"
  type        = string
}
