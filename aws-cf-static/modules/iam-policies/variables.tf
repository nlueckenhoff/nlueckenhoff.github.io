variable "bucket_arn" {
  type        = string
  description = "Bucket ARN"
  default     = ""
}

variable "cf_origin_access_id" {
  type        = string
  description = "CloudFront Origin Access Identity ARN"
  default     = ""
}

variable "primary_arn" {
  type        = string
  description = "Primary server bucket ARN"
  default     = ""
}

variable "primary_region" {
  type        = string
  description = "Primary region (Required)"
  default     = ""
}

variable "put_user" {
  type        = string
  description = "GitHub runner IAM user ARN"
  default     = ""
}

variable "ap_name" {
  type        = string
  description = "Primary server bucket S3 access point name"
  default     = ""
}

variable "failover_arn" {
  type        = string
  description = "Failover server bucket ARN"
  default     = ""
}
