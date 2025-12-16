output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

output "alb_target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.app_listener.arn
}
