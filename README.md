
# CloudMovie Challenge

CloudMovie Challenge is a containerised Flask application deployed on AWS using Terraform and GitHub Actions.

## Architecture

Internet
→ Application Load Balancer
→ Auto Scaling Group
→ Private EC2
→ Docker / Gunicorn / Flask

Supporting services:

- Amazon ECR
- DynamoDB
- Secrets Manager
- NAT Gateway
- CloudWatch
- Systems Manager
- GitHub Actions

## Key Engineering Decisions

- EC2 instances are private and have no public IP.
- ALB is the only public application entry point.
- SSM replaces SSH administration.
- Secrets Manager stores the TMDB credential.
- NAT Gateway provides controlled outbound Internet access.
- DynamoDB provides persistent application state.
- S3 Gateway Endpoint reduces NAT traffic.
- Terraform manages the infrastructure.
- GitHub Actions performs container deployment.
- ASG instance refresh performs rolling deployments.

## CI/CD

Push to main
→ Docker build
→ ECR push
→ ASG instance refresh
→ ALB health validation

## Observability

CloudWatch provides:

- application logs
- ALB metrics
- target health
- alarms
- dashboard

## Security

- private compute
- IAM least privilege
- IMDSv2
- no SSH
- security-group isolation
- Secrets Manager
- ECR image scanning

## Cost Optimisation

- t3.micro
- one-instance ASG for demo
- single NAT Gateway
- S3 Gateway Endpoint
- ephemeral dev environment
- Terraform destroy after demonstrations










# CloudMovie Challenge

CloudMovie Challenge is a cloud engineering capstone project built as part of the Ironhack Cloud Engineering Bootcamp.

The application is an entertaining movie guessing game designed primarily to demonstrate production-style AWS infrastructure and DevOps practices.

## Project Goals

The project demonstrates:

- AWS networking with public and private subnets
- EC2 compute
- Application Load Balancer
- Auto Scaling
- NAT Gateway
- Docker
- Amazon ECR
- DynamoDB
- AWS Lambda
- API Gateway
- AWS Secrets Manager
- IAM least-privilege access
- CloudWatch monitoring and logging
- SNS alerting
- Terraform Infrastructure as Code
- GitHub Actions CI/CD
- Cost-aware infrastructure lifecycle management

## Application

Players guess movies from clues and compete through a leaderboard.

A separate serverless Bonus Challenge feature is implemented using AWS Lambda.

## Status

🚧 Under active development.









# Overall VS Code / WSL structure

cloudmovie-challenge/
│
├── README.md
├── LICENSE
├── .gitignore
├── .env.example
├── Makefile
│
├── app/
│   ├── src/
│   │   ├── app.py
│   │   ├── config.py
│   │   ├── routes.py
│   │   ├── services/
│   │   │   ├── movie_service.py
│   │   │   ├── leaderboard_service.py
│   │   │   └── secrets_service.py
│   │   │
│   │   ├── templates/
│   │   │   ├── index.html
│   │   │   ├── game.html
│   │   │   └── leaderboard.html
│   │   │
│   │   └── static/
│   │       ├── css/
│   │       │   └── style.css
│   │       └── js/
│   │           └── game.js
│   │
│   ├── tests/
│   │   ├── test_app.py
│   │   └── test_routes.py
│   │
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .dockerignore
│
├── lambda/
│   └── bonus_challenge/
│       ├── handler.py
│       ├── requirements.txt
│       └── tests/
│           └── test_handler.py
│
├── infrastructure/
│   │
│   ├── bootstrap/
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── modules/
│   │   │
│   │   ├── networking/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── security/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── ecr/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── compute/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── user_data.sh.tpl
│   │   │
│   │   ├── alb/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── database/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── secrets/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── lambda/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   └── monitoring/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   └── environments/
│       └── dev/
│           ├── main.tf
│           ├── providers.tf
│           ├── variables.tf
│           ├── outputs.tf
│           ├── backend.tf
│           └── terraform.tfvars.example
│
├── .github/
│   └── workflows/
│       ├── application-ci.yml
│       ├── terraform-ci.yml
│       └── deploy.yml
│
├── scripts/
│   ├── deploy.sh
│   ├── destroy-runtime.sh
│   ├── smoke-test.sh
│   └── cost-check.sh
│
└── docs/
    ├── architecture/
    │   ├── architecture.md
    │   └── diagrams/
    │
    ├── adr/
    │   ├── ADR-001-ec2-vs-lambda.md
    │   ├── ADR-002-private-subnets.md
    │   ├── ADR-003-single-nat-gateway.md
    │   └── ADR-004-dynamodb.md
    │
    ├── security.md
    ├── monitoring.md
    ├── cost-analysis.md
    ├── deployment.md
    ├── demo-plan.md
    └── troubleshooting.md



# Step 5: AWS Networking




				Internet
        	                    │
                	  Internet Gateway
                        	     │
	┌──────────┴──────────┐
        │                     				 	 │
  Public AZ1            				  Public AZ2
   10.0.1.0/24           			  10.0.2.0/24
         │                     				  │
       ALB                   		      		ALB
         │                     				  │
         └──────────┬──────────┘
                            	      │
         ┌──────────┴──────────┐
         │                           				  │
 Private AZ1           				Private AZ2
 10.0.11.0/24          				10.0.12.0/24
         │                     			 	│
       EC2                   				EC2
