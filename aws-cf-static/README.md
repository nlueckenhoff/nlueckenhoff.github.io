# Inputs
| Name | Description | Type | Required
|---|---|:---:|:---:|
|credentials | "The location of credentials file" | string | yes
|primary\_region | "The primary region name" | string | yes
|failover\_region | "The failover region name" | string | yes
|runner\_user | "The user name for GitHub runner" | string | yes
|s3crr\_role | "The service role name for S3 cross-region replication" | string | yes
|bare\_group | "The group name for GitHub runner user (no attached policy)" | string | yes
|bare\_membership | "The group membership name for bare_group" | string | yes
|primary\_bucket\_prefix | "The primary server bucket prefix" | string | yes
|failover\_bucket\_prefix | "The failover server bucket prefix" | string | yes
|primary\_log\_bucket\_prefix | "The primary log bucket prefix" | string | yes
|failover\_log\_bucket\_prefix | "The failover log bucket prefix" | string | yes
|noncurrent\_exp | "The number of days until noncurrent object expires in lifecycle rule for all buckets" | number | yes
|tag\_set | "The map of tags applied to resources when possible" | map(string) | yes
|s3crr\_role\_policy | "The policy name_prefix for policy attached to s3crr_role" | string | yes
|primary\_server\_origin | "The name for primary server CloudFront origin id" | string | yes
|failover\_server\_origin | "The name for failover server CloudFront origin id" | string | yes
|origin\_group | "The name for CloudFront origin group id" | string | yes

# Outputs
| Name | Description |
|---|---|
|github-runner-arn | The ARN for GitHub runner user
|bare-group-arn | The ARN for the group containing GitHub runner
|s3crr-role-arn | The ARN for the S3 cross-region replication role
|s3crr-role-policy-arn | The ARN for the policy attached to the S# cross-region replication role
|primary-server-bucket-arn | The ARN for the primary region server bucket
|failover-server-bucket-arn | The ARN for the failover region server bucket
|primary-log-bucket-arn | The ARN for the primary region log bucket
|failover-log-bucket-arn | The ARN for the failover region log bucket
|s3ap-github-arn | The ARN for the S3 access point on the primary region server bucket
|server-distribution-id | The identifier for the CloudFront distribution
|server-distribution-arn | The ARN for the CloudFront distribution
|server-distribution-status | The current state of the CloudFront distribution
|server-distribution-domain | The domain name for the CloudFront distribution
|primary-oai-id | The identifier for the CloudFront distribution using the primary region origin access identity
|primary-oai-id-path | The special path prefix `origin-access-identity/cloudfront/` followed by identifier for primary region origin access identity
|failover-oai-id | The identifier for the CloudFront distribution using the failover region origin access identity
|failover-oai-id-path | The special path prefix `origin-access-identity/cloudfront/` followed by identifier for failover region origin access identity
