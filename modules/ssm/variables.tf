variable "db_username_parameter_name" {
  description = "The name of the SSM parameter for the database username"
  type        = string
  default     = "/prod/db/username"
}

variable "db_password_parameter_name" {
  description = "The name of the SSM parameter for the database password"
  type        = string
  default     = "/prod/db/password"
}

variable "db_username" {
  description = "The value of the database username"
  type        = string
}

variable "db_password" {
  description = "The value of the database password"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the SSM parameters"
  type        = string
}

variable "parameter_type" {
  description = "The type of the SSM parameter (e.g., String, SecureString, StringList)"
  type        = string
  default     = "SecureString"
}
