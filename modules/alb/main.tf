##############################################
# Application Load Balancer
##############################################
resource "aws_lb" "app_alb" {
  name               = "${var.resource_prefix}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    {
      Name        = "${var.resource_prefix}-alb"
      Environment = var.environment
    },
    var.tags
  )
}

##############################################
# Target Group
##############################################
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.resource_prefix}-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    matcher             = var.health_check_matcher
  }

  tags = merge(
    {
      Name        = "${var.resource_prefix}-tg"
      Environment = var.environment
    },
    var.tags
  )
}

##############################################
# Listener (HTTP or HTTPS)
##############################################
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
