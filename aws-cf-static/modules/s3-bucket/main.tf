terraform {
  required_providers {
    aws = ">= 2.53.0"
  }
}

# inherit provider region from root
provider "aws" {

}

# create bucket
resource "aws_s3_bucket" "bucket" {
  acl    = var.canned_acl
  bucket_prefix = var.bucket_prefix
  tags   = var.bucket_tags
  region = var.bucket_region
  dynamic "logging" {
    for_each = length(keys(var.logging_dest)) == 0 ? [] : [var.logging_dest]
    content {
      target_bucket = logging.value.target_bucket
    }
  }
  versioning {
    enabled = var.versioning
  }
  dynamic "replication_configuration" {
    for_each = length(keys(var.s3crr_arn)) == 0 ? [] : [var.s3crr_arn]
    content {
      role = replication_configuration.value.role
      rules {
        destination {
          bucket = replication_configuration.value.bucket
        }
      status = "Enabled"
      }
    }
  }
  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
    days = var.noncurrent_exp
    }
  }
}

# block all public access to bucket
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}