variable "region" {
  description = "AWS region for the distribution/data lookups (unused by resource but available)"
  type        = string
  default     = "us-east-1"
}

variable "app_domain_primary" {
  description = "Primary application domain (e.g., app.example.com) used as CloudFront alias"
  type        = string
  default     = ""
}

variable "app_domain_secondary" {
  description = "Secondary application domain (e.g., api.example.com) used as CloudFront alias"
  type        = string
  default     = ""
}

variable "log_bucket_name" {
  description = "S3 bucket name (no suffix) to receive CloudFront logs"
  type        = string
  default     = ""
}

variable "enable_cf_logging" {
  description = "Whether to enable CloudFront logging to the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Whether CloudFront should be IPv6 enabled"
  type        = bool
  default     = true
}

# Optional tuning variables used by distribution (provide defaults matching main.tf's behavior)
variable "price_class" {
  description = "CloudFront price class to use"
  type        = string
  default     = "PriceClass_100"
}

variable "http_version" {
  description = "HTTP protocol versions supported by CloudFront"
  type        = string
  default     = "http2and3"
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy for default cache behavior"
  type        = string
  default     = "redirect-to-https"
}

variable "minimum_protocol_version" {
  description = "Minimum TLS version for viewer certificate"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "wait_for_deployment" {
  description = "Wait for CloudFront distribution deployment to complete"
  type        = bool
  default     = true
}

variable "logging_prefix_primary" {
  description = "Prefix to use for primary distribution logs in the log bucket"
  type        = string
  default     = "cloudfront/primary/"
}

variable "logging_prefix_secondary" {
  description = "Prefix to use for secondary distribution logs in the log bucket"
  type        = string
  default     = "cloudfront/secondary/"
}

variable "hosted_zone_name" {
  description = "The domain name of the Route 53 hosted zone (e.g., example.com)"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "The domain name of the ALB to use as origin"
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "The Route 53 Hosted Zone ID where DNS records will be created"
  type        = string
  default     = ""
}
