variable "config_role_arn" {
  description = "The ARN of the IAM role that AWS Config uses"
  type        = string
}
 
variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}
 
variable "recording_gp_all_supported" {
  description = "Indicates whether AWS Config should record all supported resources."
  type        = bool
 
}
 
variable "recording_gp_global_resources_included" {
  description = "Whether to include global resource types in the recording group"
  type        = bool
 
}
 
variable "recorder_status_enabled" {
  description = "Indicates whether the configuration recorder should be enabled"
  type        = bool
 
}
 
variable "config_rules" {
  description = "List of AWS Config rules to create"
  type = list(object({
    name                        = string
    source_identifier           = string
    input_parameters            = optional(string)
    compliance_resource_types   = optional(list(string))
  }))
}
 
 