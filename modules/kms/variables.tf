variable "description" {
  description = "Description of the KMS key"
  type        = string
}

variable "deletion_window_in_days" {
  description = "Number of days before the KMS key is deleted"
  type        = number
  default     = 10
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "alias" {
  description = "Alias name for the KMS key"
  type        = string
}
