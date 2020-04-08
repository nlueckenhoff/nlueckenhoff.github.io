# add unique ids if necessary

output "github-runner-arn" {
  value = aws_iam_user.github-runner.arn
}

output "bare-group-arn" {
  value = aws_iam_group.bare-group.arn
}

output "s3crr-role-arn" {
  value = aws_iam_role.s3crr-role.arn
}

output "s3crr-role-policy-arn" {
  value = aws_iam_policy.s3crr-role-policy.arn
}

output "primary-server-bucket-arn" {
  value = module.primary-server-bucket.arn
}

output "failover-server-bucket-arn" {
  value = module.failover-server-bucket.arn
}

output "primary-log-bucket-arn" {
  value = module.primary-log-bucket.arn
}

output "failover-log-bucket-arn" {
  value = module.failover-log-bucket.arn
}

output "s3ap-github-arn" {
  value = aws_s3_access_point.s3ap-github.arn
}

output "server-distribution-id" {
  value = aws_cloudfront_distribution.server-distribution.id
}

output "server-distribution-arn" {
  value = aws_cloudfront_distribution.server-distribution.arn
}

output "server-distribution-status" {
  value = aws_cloudfront_distribution.server-distribution.status
}

output "server-distribution-domain" {
  value = aws_cloudfront_distribution.server-distribution.domain_name
}

output "primary-oai-id" {
  value = aws_cloudfront_origin_access_identity.primary-oai.id
}

output "primary-oai-id-path" {
  value = aws_cloudfront_origin_access_identity.primary-oai.cloudfront_access_identity_path
}

output "failover-oai-id" {
  value = aws_cloudfront_origin_access_identity.failover-oai.id
}

output "failover-oai-id-path" {
  value = aws_cloudfront_origin_access_identity.failover-oai.cloudfront_access_identity_path
}