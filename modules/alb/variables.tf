##############################################
# General Configuration
##############################################
variable "resource_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB placement"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

##############################################
# ALB Configuration
##############################################
variable "internal" {
  description = "Whether the ALB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection on the ALB"
  type        = bool
  default     = false
}

##############################################
# Target Group Configuration
##############################################
variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Target type: instance, ip, or lambda"
  type        = string
  default     = "instance"
}

variable "health_check_path" {
  description = "Health check path for targets"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Expected HTTP response codes for health check"
  type        = string
  default     = "200-399"
}
variable "health_check_enabled" {
  description = "Whether health checks are enabled"
  type        = bool
  default     = true
}
variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before considering a target healthy"
  type        = number
  default     = 3
}
variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering a target unhealthy"
  type        = number
  default     = 3
}
variable "health_check_interval" {
  description = "Interval (in seconds) between health checks"
  type        = number
  default     = 30
}
variable "health_check_timeout" {
  description = "Timeout (in seconds) for each health check"
  type        = number
  default     = 5
}



##############################################
# Listener Configuration
##############################################
variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
  default     = "HTTP"
}

##############################################
# Additional Tags
##############################################
variable "tags" {
  description = "Additional tags for ALB and related resources"
  type        = map(string)
  default     = {}
}
