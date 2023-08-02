variable "bucket_prefix" {
  type        = string
  description = "Prefix for bucket name (Required)"
}

variable "bucket_region" {
  type        = string
  description = "Region for bucket (Required)"
}

variable "bucket_tags" {
  type        = map(string)
  description = "Tags for bucket (Required)"
}

variable "canned_acl" {
  type        = string
  description = "Canned acl to apply (Optional)"
  default     = "private"
}

variable "logging_dest" {
  description = "Target bucket name for receiving logs"
  type        = map(string)
  default     = {}
}

variable "noncurrent_exp" {
  type        = number
  description = "Days before noncurrent object expires (Required)"
}

variable "s3crr_arn" {
  description = "ARN of IAM role S3 assumes for cross-region replication"
  type        = map(string)
  default     = {}
}

variable "versioning" {
  type        = string
  description = "Versioning for bucket objects (Optional)"
  default     = "false"
}