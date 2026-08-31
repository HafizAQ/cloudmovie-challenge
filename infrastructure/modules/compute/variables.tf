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
