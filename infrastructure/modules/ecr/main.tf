resource "aws_ecr_repository" "app" {
  name = "${var.project_name}-${var.environment}"

  image_tag_mutability = "MUTABLE"

  # force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        description = "Keep only five images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_pull" {
  name = "${var.project_name}-ecr-pull"

  role = var.ec2_role_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]

        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}
