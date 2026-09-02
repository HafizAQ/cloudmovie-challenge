resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-${var.environment}-alb-"

  description = "Internet traffic to Application Load Balancer"

  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name_prefix = "${var.project_name}-${var.environment}-app-"

  description = "Application EC2 instances"

  vpc_id = var.vpc_id

  ingress {
    description = "Application traffic from ALB"

    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-instance-profile"

  role = aws_iam_role.ec2.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {

  role = aws_iam_role.ec2.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_security_group_rule" "app_from_alb" {

  type = "ingress"

  security_group_id = aws_security_group.app.id


  source_security_group_id = aws_security_group.alb.id


  from_port = 5000

  to_port = 5000

  protocol = "tcp"

}
