#############################################################################
## All outputs from the creation of a cloudfront distribution defined here ##
#############################################################################

output "oai_iam_arn" {
    description = "Cloudfront Origin Access Identity IAM ARN (for use in bucket policies)"
    value       = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}
