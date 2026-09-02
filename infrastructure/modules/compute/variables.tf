variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "create_standalone" {
  type    = bool
  default = false
}

variable "target_group_arns" {
  description = "Target groups attached to the application Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "enable_asg" {
  description = "Whether to create the application Auto Scaling Group"
  type        = bool
  default     = false
}

variable "dynamodb_table_name" {
  description = "DynamoDB leaderboard table name"
  type        = string
}

variable "tmdb_secret_arn" {
  type = string
}

variable "cloudwatch_config" {
  description = "CloudWatch Agent configuration"
  type        = string
}


variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group receiving Docker application logs"
  type        = string
}


