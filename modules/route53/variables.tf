variable "zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
}

variable "app_subdomain" {
  description = "Subdomain for the app (e.g., app.dev.example.com)"
  type        = string
}

variable "api_subdomain" {
  description = "Subdomain for the API (e.g., api.dev.example.com)"
  type        = string
}

variable "app_distribution_domain_name" {
  description = "Domain name of the app CloudFront distribution"
  type        = string
}

variable "api_distribution_domain_name" {
  description = "Domain name of the API CloudFront distribution"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID for CloudFront (always Z2FDTNDATAQYW2)"
  type        = string
  default     = "Z2FDTNDATAQYW2"
}
