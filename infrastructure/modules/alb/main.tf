resource "aws_lb" "app" {
  name               = "${var.project_name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.security_group_id
  ]

  subnets = var.public_subnet_ids

  drop_invalid_header_fields = true

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name = "${var.project_name}-${var.environment}"

  port     = 5000
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    enabled = true

    path = "/health"

    protocol = "HTTP"
    port     = "traffic-port"

    healthy_threshold   = 2
    unhealthy_threshold = 2

    timeout  = 5
    interval = 15

    matcher = "200"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.app.arn
  }
}
