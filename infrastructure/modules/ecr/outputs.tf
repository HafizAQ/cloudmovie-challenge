output "repository_url" {
  description = "URL of the ECR application repository"
  value       = aws_ecr_repository.app.repository_url
}


output "repository_arn" {
  value = aws_ecr_repository.app.arn
}
