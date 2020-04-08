output "log-policy-json" {
  value = data.aws_iam_policy_document.log-policy.json
}

output "server-primary-policy-json" {
  value = data.aws_iam_policy_document.server-primary-policy.json
}

output "server-failover-policy-json" {
  value = data.aws_iam_policy_document.server-failover-policy.json
}

output "s3crr-assume-role-policy-json" {
  value = data.aws_iam_policy_document.s3crr-assume-role-policy.json
}

output "s3crr-policy-json" {
  value = data.aws_iam_policy_document.s3crr-policy.json
}

output "s3ap-policy-json" {
  value = data.aws_iam_policy_document.s3ap-policy.json
}