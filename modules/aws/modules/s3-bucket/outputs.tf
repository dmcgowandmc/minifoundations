############################################################
## All outputs from the creation of s3 bucket reside here ##
############################################################

output "s3_bucket_name" {
    description = "The name of the bucket (excluding random prefix)"
    value       = var.bucket_name
}

output "s3_bucket_id" {
    description = "The name of the bucket (random prefix + bucket name)"
    value       = module.s3_bucket.this_s3_bucket_id
}

output "s3_bucket_arn" {
    description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
    value       = module.s3_bucket.this_s3_bucket_arn
}
