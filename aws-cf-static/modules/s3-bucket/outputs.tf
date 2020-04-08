output "arn" {
  value = aws_s3_bucket.bucket.arn
}

output "id" {
  value = aws_s3_bucket.bucket.id
}

output "regional-name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}