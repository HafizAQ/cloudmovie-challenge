# Least privilege
resource "aws_dynamodb_table" "leaderboard" {
  name = "${var.project_name}-${var.environment}-leaderboard"

  billing_mode = "PROVISIONED"

  read_capacity  = 5
  write_capacity = 5

  hash_key = "player_id"

  attribute {
    name = "player_id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = false
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-leaderboard"
  }
}

resource "aws_iam_role_policy" "dynamodb" {
  name = "${var.project_name}-${var.environment}-dynamodb"
  role = var.ec2_role_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ]

        Resource = aws_dynamodb_table.leaderboard.arn
      }
    ]
  })
}
