data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-${var.environment}-"

  image_id      = data.aws_ssm_parameter.amazon_linux.value
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.security_group_id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  user_data = base64encode(
    templatefile(
      "${path.module}/user_data.sh.tpl",
      {
        aws_region         = var.aws_region
        ecr_repository_url = var.ecr_repository_url
      }
    )
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-app"
    }
  }
}

resource "aws_instance" "standalone" {
  count = var.create_standalone ? 1 : 0

  subnet_id = var.private_subnet_ids[0]

  # associate_public_ip_address = false

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-validation"
  }
}
