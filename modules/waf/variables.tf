variable "scope" {
  type        = string
  description = "Scope: REGIONAL or CLOUDFRONT"
}

variable "enable_cloudwatch_metrics" {
  type    = bool
  default = true
}

variable "associated_arns" {
  type        = list(string)
  description = "List of resource ARNs the WAF should protect"
  default     = []
}

variable "resource_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

