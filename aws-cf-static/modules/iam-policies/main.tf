terraform {
  required_providers {
    aws = ">= 2.53.0"
  }
}

data "aws_caller_identity" "current" {}

# render log bucket policy
data "aws_iam_policy_document" "log-policy" {
  statement {
    sid       = 1
    effect    = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = [
      "s3:*",
    ]
    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [
      "false",
      ]
    }
  }
}

# render primary server bucket policy
data "aws_iam_policy_document" "server-primary-policy" {
  statement {
    sid       = 1
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.cf_origin_access_id]
    }
    actions   = [
      "s3:GetObject",
      ]
    resources = [
      "${var.bucket_arn}/*",
    ]
  }

  statement {
    sid       = 2
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.put_user]
    }
    actions   = [
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = [
    "${var.bucket_arn}/*",
    ]
  }

  statement {
    sid       = 3
    effect    = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = [
      "s3:*",
    ]
    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [
      "false",
      ]
    }
  }
}

# render failover server bucket policy
data "aws_iam_policy_document" "server-failover-policy" {
  statement {
    sid       = 1
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.cf_origin_access_id]
    }
    actions   = [
      "s3:GetObject",
      ]
    resources = [
      "${var.bucket_arn}/*",
    ]
  }

  statement {
    sid       = 2
    effect    = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = [
      "s3:*",
    ]
    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [
      "false",
      ]
    }
  }
}

# render s3 access point policy for github runner
data "aws_iam_policy_document" "s3ap-policy" {
  statement {
    sid       = 1
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.put_user]
    }
    actions   = [
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = [
      "arn:aws:s3:${var.primary_region}:${data.aws_caller_identity.current.account_id}:accesspoint/${var.ap_name}/object/*",
    ]
  }
}


# render s3 service access policy
data "aws_iam_policy_document" "s3crr-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

#render s3 cross-region replication policy
data "aws_iam_policy_document" "s3crr-policy" {
  statement {
    sid       = 1
    effect    = "Allow"
    actions   = [
      "s3:Get*",
      "s3:ListBucket",
    ]
    resources = [
      "${var.primary_arn}",
      "${var.primary_arn}/*",
    ]
  }

  statement {
    sid       = 2
    effect    = "Allow"
    actions   = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
    ]
    resources = [
      "${var.failover_arn}/*",
    ]
  }
}