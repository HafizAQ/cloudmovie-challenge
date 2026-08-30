variable "project_name" {
  description = "Project name"
  type        = string
  default     = "cloudmovie-challenge"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}


variable "enable_nat" {
  description = "Create NAT Gateway for private subnet Internet access"
  type        = bool
  default     = false
}


