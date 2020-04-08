terraform {
  required_providers {
    aws = "~> 2.54.0"
  }
}

# set default region
provider "aws" {
  region = var.primary_region
}

# set primary region alias
provider "aws" {
  alias                   = "primary-region"
  region                  = var.primary_region
  shared_credentials_file = var.credentials
}

# set failover region alias
provider "aws" {
  alias                   = "failover-region"
  region                  = var.failover_region
  shared_credentials_file = var.credentials
}

# declare iam policy data module
module "iam-policies" {
  source = "./modules/iam-policies"
}

# create iam user for github runner
resource "aws_iam_user" "github-runner" {
  name = var.runner_user
  tags = var.tag_set
}

# create iam group for github-runner
resource "aws_iam_group" "bare-group" {
  name = var.bare_group
}

# manage membership for bare-group
resource "aws_iam_group_membership" "bare-membership" {
  name  = var.bare_membership
  users = [
    aws_iam_user.github-runner.name,
    ]
  group = aws_iam_group.bare-group.name
}

# create primary region s3 bucket for access logs
module "primary-log-bucket" {
  source        = "./modules/s3-bucket"
  providers     = {
    aws = aws.primary-region
  }
  canned_acl    = "log-delivery-write"
  bucket_prefix   = var.primary_log_bucket_prefix
  bucket_region = var.primary_region
  bucket_tags   = var.tag_set
  noncurrent_exp    = var.noncurrent_exp
}

# create failover region s3 bucket for access logs
module "failover-log-bucket" {
  source        = "./modules/s3-bucket"
  providers     = {
    aws = aws.failover-region
  }
  canned_acl    = "log-delivery-write"
  bucket_prefix   = var.failover_log_bucket_prefix
  bucket_region = var.failover_region
  bucket_tags   = var.tag_set
  noncurrent_exp    = var.noncurrent_exp
}

# create primary region s3 server bucket
module "primary-server-bucket" {
  source        = "./modules/s3-bucket"
  providers     = {
    aws = aws.primary-region
  }
  versioning          = "true"
  bucket_prefix         = var.primary_bucket_prefix
  bucket_region       = var.primary_region
  bucket_tags         = var.tag_set
  noncurrent_exp          = var.noncurrent_exp
  logging_dest        = {
    "target_bucket" = module.primary-log-bucket.id
  }
  s3crr_arn        = {
    "role" = aws_iam_role.s3crr-role.arn
    "bucket" = module.failover-server-bucket.arn
  }
}

# render policy for s3 primary server bucket access point
module "access-point-policy" {
  source = "./modules/iam-policies"
  primary_region = var.primary_region
  put_user = aws_iam_user.github-runner.arn
  ap_name = "s3ap-${module.primary-server-bucket.id}"
}

# create primary s3 server bucket access point for github runner and attach policy
resource "aws_s3_access_point" "s3ap-github" {
  bucket = module.primary-server-bucket.id
  name = "s3ap-${module.primary-server-bucket.id}"
  policy = module.access-point-policy.s3ap-policy-json
}

# create failover region s3 server bucket
module "failover-server-bucket" {
  source        = "./modules/s3-bucket"
  providers     = {
    aws = aws.failover-region
  }
  versioning          = "true"
  bucket_prefix         = var.failover_bucket_prefix
  bucket_region       = var.failover_region
  bucket_tags         = var.tag_set
  noncurrent_exp          = var.noncurrent_exp
  logging_dest        = {
    "target_bucket" = module.failover-log-bucket.id
  }
}

# create cross-region replication role and attach access policy for s3 service
resource "aws_iam_role" "s3crr-role" {
  name               = var.s3crr_role
  path               = "/service-role/"
  assume_role_policy = module.iam-policies.s3crr-assume-role-policy-json
  tags = var.tag_set
}

# render policy for cross-region replication
module "s3crr-policy" {
  source = "./modules/iam-policies"
  primary_arn   = module.primary-server-bucket.arn
  failover_arn = module.failover-server-bucket.arn
}

# create policy for cross-region replication role
resource "aws_iam_policy" "s3crr-role-policy" {
  name_prefix = var.s3crr_role_policy
  path = "/service-role/"
  policy = module.s3crr-policy.s3crr-policy-json
}

# attach cross-region replication policy to role
resource "aws_iam_role_policy_attachment" "attach-s3crr-role-policy" {
  role = aws_iam_role.s3crr-role.name
  policy_arn = aws_iam_policy.s3crr-role-policy.arn
}

# create cloudfront origin access identity for primary server bucket
resource "aws_cloudfront_origin_access_identity" "primary-oai" {}

# create cloudfront origin access identity for failover server bucket
resource "aws_cloudfront_origin_access_identity" "failover-oai" {}

# create cloudfront distribution with origin group for failover
resource "aws_cloudfront_distribution" "server-distribution" {
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = "false"
    }
    target_origin_id = var.origin_group
    viewer_protocol_policy = "redirect-to-https"
  }
  default_root_object = "index.html"
  enabled = "true"
  is_ipv6_enabled = "true"
  origin_group {
    origin_id = var.origin_group
    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }
    member {
      origin_id = var.primary_server_origin
    }
    member {
      origin_id = var.failover_server_origin
    }
  }
  origin {
    domain_name = module.primary-server-bucket.regional-name
    origin_id   = var.primary_server_origin
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.primary-oai.cloudfront_access_identity_path
    }
  }
  origin {
    domain_name = module.failover-server-bucket.regional-name
    origin_id   = var.failover_server_origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.failover-oai.cloudfront_access_identity_path
    }
  }
  price_class = "PriceClass_All"
  tags = var.tag_set
  viewer_certificate {
    cloudfront_default_certificate = "true"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  wait_for_deployment = "false"
}

# render policy for primary region log bucket
module "primary-log-bucket-policy" {
  source = "./modules/iam-policies"
  bucket_arn = module.primary-log-bucket.arn
}

# render policy for failover region log bucket
module "failover-log-bucket-policy" {
  source = "./modules/iam-policies"
  bucket_arn = module.failover-log-bucket.arn
}

# attach policy to primary region log bucket
module "attach-primary-log-policy" {
  source = "./modules/s3-bucket-policy"
  bucket = module.primary-log-bucket.id
  policy = module.primary-log-bucket-policy.log-policy-json
}

# attach policy to failover region log bucket
module "attach-failover-log-policy" {
  source = "./modules/s3-bucket-policy"
  providers     = {
    aws = aws.failover-region
  }
  bucket = module.failover-log-bucket.id
  policy = module.failover-log-bucket-policy.log-policy-json
}

# render policy for primary region server bucket
module "primary-server-bucket-policy" {
  source = "./modules/iam-policies"
  bucket_arn = module.primary-server-bucket.arn
  put_user = aws_iam_user.github-runner.arn
  cf_origin_access_id = aws_cloudfront_origin_access_identity.primary-oai.iam_arn
}

# render policy for failover region server bucket
module "failover-server-bucket-policy" {
  source = "./modules/iam-policies"
  bucket_arn = module.failover-server-bucket.arn
  cf_origin_access_id = aws_cloudfront_origin_access_identity.failover-oai.iam_arn
}

# attach policy to primary region server bucket
module "attach-primary-server-policy" {
  source = "./modules/s3-bucket-policy"
  bucket = module.primary-server-bucket.id
  policy = module.primary-server-bucket-policy.server-primary-policy-json
}

# attach policy to failover region server bucket
module "attach-failover-server-policy" {
  source = "./modules/s3-bucket-policy"
  providers     = {
    aws = aws.failover-region
  }
  bucket = module.failover-server-bucket.id
  policy = module.failover-server-bucket-policy.server-failover-policy-json
}