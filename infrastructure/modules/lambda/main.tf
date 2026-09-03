data "archive_file" "bonus" {
  type        = "zip"
  source_file = var.lambda_source_file
  output_path = "${path.root}/.terraform/cloudmovie-bonus.zip"
}


resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-${var.environment}-bonus-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "basic_execution" {
  role = aws_iam_role.lambda.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy" "secret_access" {
  role = aws_iam_role.lambda.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.tmdb_secret_arn
      }
    ]
  })
}


resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${var.project_name}-${var.environment}-bonus-challenge"

  retention_in_days = 3
}



resource "aws_lambda_function" "bonus" {
  function_name = "${var.project_name}-${var.environment}-bonus-challenge"

  role = aws_iam_role.lambda.arn

  runtime = "python3.12"
  handler = "lambda_function.handler"

  filename         = data.archive_file.bonus.output_path
  source_code_hash = data.archive_file.bonus.output_base64sha256

  memory_size = 128
  timeout     = 10

  architectures = [
    "arm64"
  ]

  environment {
    variables = {
      TMDB_SECRET_ID = var.tmdb_secret_arn
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.basic_execution,
    aws_iam_role_policy.secret_access,
  ]
}
