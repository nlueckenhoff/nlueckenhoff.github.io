variable "credentials" {
  type        = string
  description = "The location of credentials file"
}

variable "primary_region" {
  type        = string
  description = "The primary region name"
}

variable "failover_region" {
  type        = string
  description = "The failover region name"
}

variable "runner_user" {
  type        = string
  description = "The user name for github runner"
}

variable "s3crr_role" {
  type        = string
  description = "The service role name for s3 cross-region replication"
}

variable "bare_group" {
  type        = string
  description = "The group name for github runner user (no attached policy)"
}

variable "bare_membership" {
  type        = string
  description = "The group membership name for bare_group"
}

variable "primary_bucket_prefix" {
  type        = string
  description = "The primary server bucket prefix"
}

variable "failover_bucket_prefix" {
  type        = string
  description = "The failover server bucket prefix"
}

variable "primary_log_bucket_prefix" {
  type        = string
  description = "The primary log bucket prefix"
}

variable "failover_log_bucket_prefix" {
  type        = string
  description = "The failover log bucket prefix"
}

variable "noncurrent_exp" {
  type        = number
  description = "The number of days until noncurrent object expires in lifecycle rule for all buckets"
}

variable "tag_set" {
  type        = map(string)
  description = "The map of tags applied to resources when possible"
}

variable "s3crr_role_policy" {
  type        = string
  description = "The policy name_prefix for policy attached to s3crr_role"
}

variable "primary_server_origin" {
  type        = string
  description = "The name for primary server cloudfront origin id"
}

variable "failover_server_origin" {
  type        = string
  description = "The name for failover server cloudfront origin id"
}

variable "origin_group" {
  type        = string
  description = "The name for cloudfront origin group id"
}