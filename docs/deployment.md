# CloudMovie Challenge — Deployment Guide

## Prerequisites

Required local tools:

- Git
- Docker
- Terraform
- AWS CLI
- Python 3
- GitHub repository access

AWS region:

```text
eu-central-1
```

Project root:

```bash
~/Ironhack/Week9/final-project/cloudmovie-challenge
```

---

## 1. Configure AWS CLI

Verify identity:

```bash
aws sts get-caller-identity
```

Set the region explicitly:

```bash
export AWS_REGION=eu-central-1
export AWS_DEFAULT_REGION=eu-central-1
```

Using an explicit region is recommended for every AWS CLI command.

---

## 2. Test the Application Locally

From the repository root:

```bash
cd ~/Ironhack/Week9/final-project/cloudmovie-challenge
```

Run tests:

```bash
pytest app/tests -v
```

Local Flask development server:

```bash
PYTHONPATH=app flask --app src.app:create_app run --debug
```

Or:

```bash
cd app
gunicorn --bind 0.0.0.0:5000 "src.app:create_app()"
```

Health endpoint:

```bash
curl http://127.0.0.1:5000/health
```

---

## 3. Build the Docker Image

From project root:

```bash
docker build   -t cloudmovie-challenge:local   ./app
```

Run locally:

```bash
docker run   --detach   --name cloudmovie-local   --publish 5000:5000   cloudmovie-challenge:local
```

Verify:

```bash
curl http://127.0.0.1:5000/health
```

Remove local test container when finished:

```bash
docker rm -f cloudmovie-local
```

---

## 4. Terraform Backend

Terraform environment root:

```bash
cd infrastructure/environments/dev
```

Initialise:

```bash
terraform init   -reconfigure   -backend-config=backend.hcl
```

The backend stores Terraform state in S3.

The local `backend.hcl` file should not be committed.

---

## 5. Validate Terraform

Format:

```bash
terraform fmt -recursive ../../
```

Validate:

```bash
terraform validate
```

Create a saved plan:

```bash
terraform plan -out=tfplan
```

Review the plan carefully before applying.

Apply:

```bash
terraform apply tfplan
```

---

## 6. Retrieve Terraform Outputs

```bash
terraform output
```

Useful shell variables:

```bash
export ALB_DNS=$(terraform output -raw alb_dns_name)
export ASG_NAME=$(terraform output -raw autoscaling_group_name)
export TG_ARN=$(terraform output -raw target_group_arn)
export ECR_URL=$(terraform output -raw ecr_repository_url)
export SECRET_ARN=$(terraform output -raw tmdb_secret_arn)
```

---

## 7. Store the TMDB Token

The secret value is deliberately not managed by Terraform.

Read the token without displaying it:

```bash
read -s TMDB_TOKEN
```

Create a temporary JSON file:

```bash
printf '{"TMDB_API_TOKEN":"%s"}'   "$TMDB_TOKEN"   > /tmp/tmdb-secret.json
```

Restrict permissions:

```bash
chmod 600 /tmp/tmdb-secret.json
```

Upload:

```bash
aws secretsmanager put-secret-value   --secret-id "$SECRET_ARN"   --secret-string file:///tmp/tmdb-secret.json   --region eu-central-1
```

Clean up:

```bash
rm -f /tmp/tmdb-secret.json
unset TMDB_TOKEN
```

Do not commit the token to Git.

---

## 8. Manual ECR Push

Authenticate:

```bash
aws ecr get-login-password   --region eu-central-1 | docker login   --username AWS   --password-stdin   "$(echo "$ECR_URL" | cut -d/ -f1)"
```

Tag:

```bash
docker tag   cloudmovie-challenge:local   "$ECR_URL:latest"
```

Push:

```bash
docker push "$ECR_URL:latest"
```

---

## 9. GitHub Actions Deployment

The deployment workflow is stored at:

```text
.github/workflows/deploy.yml
```

The workflow performs:

1. Repository checkout
2. AWS credential configuration
3. Docker build
4. ECR login
5. Docker tag
6. ECR push
7. ASG instance refresh
8. Deployment status wait

Required GitHub Actions secrets include:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
ECR_URL
```

For a production implementation, GitHub OIDC federation would be preferred over long-lived AWS access keys.

---

## 10. Trigger Deployment

Push an application change to `main`:

```bash
git add .
git commit -m "feat: update application"
git push origin main
```

The workflow can be monitored from:

```text
GitHub repository
→ Actions
→ Deploy CloudMovie
```

A successful deployment should show all deployment steps passing.

---

## 11. Validate ASG

```bash
aws autoscaling describe-auto-scaling-groups   --auto-scaling-group-names "$ASG_NAME"   --region eu-central-1   --query 'AutoScalingGroups[0].Instances[*].{Instance:InstanceId,State:LifecycleState,Health:HealthStatus}'   --output table
```

Expected state:

```text
InService
Healthy
```

---

## 12. Validate Target Health

```bash
aws elbv2 describe-target-health   --target-group-arn "$TG_ARN"   --region eu-central-1   --query 'TargetHealthDescriptions[*].{Instance:Target.Id,State:TargetHealth.State,Reason:TargetHealth.Reason}'   --output table
```

Expected:

```text
healthy
```

---

## 13. Validate Application

Health:

```bash
curl "http://$ALB_DNS/health"
```

Expected:

```json
{
  "service": "cloudmovie-challenge",
  "status": "healthy"
}
```

TMDB integration:

```bash
curl "http://$ALB_DNS/api/movie-spotlight"
```

Expected response contains movie data such as:

```json
{
  "title": "...",
  "overview": "...",
  "rating": 8.4,
  "release_date": "..."
}
```

---

## 14. Validate DynamoDB

```bash
aws dynamodb scan   --table-name cloudmovie-challenge-dev-leaderboard   --region eu-central-1
```

Leaderboard data should remain available even if the EC2 instance is replaced.

---

## 15. Validate the Container Through SSM

Retrieve current instance ID:

```bash
INSTANCE_ID=$(aws autoscaling describe-auto-scaling-groups   --auto-scaling-group-names "$ASG_NAME"   --region eu-central-1   --query 'AutoScalingGroups[0].Instances[0].InstanceId'   --output text)
```

Run Docker inspection through Systems Manager:

```bash
COMMAND_ID=$(aws ssm send-command   --instance-ids "$INSTANCE_ID"   --document-name "AWS-RunShellScript"   --region eu-central-1   --parameters 'commands=["docker ps"]'   --query 'Command.CommandId'   --output text)
```

Retrieve output:

```bash
sleep 3

aws ssm get-command-invocation   --command-id "$COMMAND_ID"   --instance-id "$INSTANCE_ID"   --region eu-central-1   --query 'StandardOutputContent'   --output text
```

The `cloudmovie` container should be running and healthy.

---

## 16. Validate Self-Healing

For a controlled demonstration, terminate the current ASG instance without decreasing desired capacity:

```bash
aws autoscaling terminate-instance-in-auto-scaling-group   --instance-id "$INSTANCE_ID"   --no-should-decrement-desired-capacity   --region eu-central-1
```

The ASG should launch a replacement.

Monitor:

```bash
aws autoscaling describe-auto-scaling-groups   --auto-scaling-group-names "$ASG_NAME"   --region eu-central-1   --query 'AutoScalingGroups[0].Instances[*].{Instance:InstanceId,State:LifecycleState,Health:HealthStatus}'   --output table
```

Then validate the replacement target through the ALB.

This test should not be repeated unnecessarily because it creates additional deployment activity.

---

## 17. Destroy the Development Environment

Before destroying:

- Capture presentation screenshots
- Verify documentation
- Confirm no demonstration is scheduled immediately
- Ensure Terraform state is healthy

Plan destruction:

```bash
cd infrastructure/environments/dev

terraform plan   -destroy   -out=destroy.tfplan
```

Review carefully.

Destroy:

```bash
terraform apply destroy.tfplan
```

This is important because ALB, NAT Gateway and EC2 continue to generate cost while the environment remains deployed.

The remote Terraform state infrastructure may be managed separately and should not be accidentally destroyed if it is intentionally retained.
