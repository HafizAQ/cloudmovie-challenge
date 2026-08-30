variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "cloudmovie-challenge"
}

variable "aws_region" {
  description = "AWS region used by the project"
  type        = string
  default     = "eu-central-1"
}


variable "enable_nat" {
  description = "Create NAT Gateway for private subnet Internet access"
  type        = bool
  default     = false
}
