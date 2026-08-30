data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Capstone"
  }
}


module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  environment  = var.environment

  enable_nat = var.enable_nat
}


# Add root module:

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id
}




