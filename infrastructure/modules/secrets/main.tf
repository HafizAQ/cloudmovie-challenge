resource "aws_secretsmanager_secret" "tmdb" {

  name = "${var.project_name}-${var.environment}-tmdb"

  description = "TMDB API access token for CloudMovie Challenge"

  recovery_window_in_days = 0

  tags = {
    Name = "${var.project_name}-${var.environment}-tmdb"
  }
}


resource "aws_iam_role_policy" "secret_access" {

  role = var.ec2_role_name


  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.tmdb.arn
      }

    ]

  })
}