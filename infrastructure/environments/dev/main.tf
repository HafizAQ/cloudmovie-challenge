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

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment

  ec2_role_name = module.security.ec2_role_name
}

module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  private_subnet_ids = module.networking.private_subnet_ids

  security_group_id = module.security.app_security_group_id

  instance_profile_name = module.security.instance_profile_name

  ecr_repository_url = module.ecr.repository_url

  dynamodb_table_name = module.database.table_name

  tmdb_secret_arn = module.secrets.secret_arn

  cloudwatch_config = file(
    "${path.module}/../../modules/compute/cloudwatch-agent.json.tpl"
  )

  instance_type = var.instance_type

  create_standalone = var.create_standalone
  enable_asg        = var.enable_asg

  cloudwatch_log_group_name = module.monitoring.log_group_name

  target_group_arns = [
    module.alb.target_group_arn
  ]

}


module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.networking.vpc_id

  public_subnet_ids = module.networking.public_subnet_ids

  security_group_id = module.security.alb_security_group_id
}

module "database" {
  source = "../../modules/database"

  project_name = var.project_name
  environment  = var.environment

  ec2_role_name = module.security.ec2_role_name
}


module "secrets" {

  source = "../../modules/secrets"


  project_name = var.project_name

  environment = var.environment

  ec2_role_name = module.security.ec2_role_name


}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  dynamodb_table_name      = module.database.table_name
  alert_email              = var.alert_email
  load_balancer_arn_suffix = module.alb.load_balancer_arn_suffix
  target_group_arn_suffix  = module.alb.target_group_arn_suffix
}


module "lambda" {
  source = "../../modules/lambda"

  project_name = var.project_name
  environment  = var.environment

  tmdb_secret_arn = module.secrets.secret_arn

  lambda_source_file = "${path.root}/../../../lambda/bonus_challenge/lambda_function.py"
}



