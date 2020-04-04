###########################################################
## All variables for creation of s3 buckets resides here ##
###########################################################

variable "bucket_name" {
    type        = string
    description = "The name of the bucket"
}

variable "block_public_acls" {
    description = "Whether Amazon S3 should block public ACLs for this bucket."
    type        = bool
    default     = false
}

variable "ignore_public_acls" {
    description = "Whether Amazon S3 should ignore public ACLs for this bucket."
    type        = bool
    default     = false
}

variable "block_public_policy" {
    description = "Whether Amazon S3 should block public bucket policies for this bucket."
    type        = bool
    default     = false
}

variable "restrict_public_buckets" {
    description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
    type        = bool
    default     = false
}

variable "server_side_encryption_configuration" {
    description = "Map containing server-side encryption configuration. Not optional. At minimum, you should use AWS default encryption"
    type        = any
}