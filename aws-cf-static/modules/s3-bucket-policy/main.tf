# attach policy to bucket
resource "aws_s3_bucket_policy" "attach-policy" {
  bucket = var.bucket
  policy = var.policy
}