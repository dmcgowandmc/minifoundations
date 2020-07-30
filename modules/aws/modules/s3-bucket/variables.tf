###########################################################
## All variables for creation of s3 buckets resides here ##
###########################################################

#Environment code used with customer code and project code to create a unique identifier when used outside foundations. For buckets, only part of the tag strategy
variable "environment_code" {
    type        = string
    description = "2 - 4 letter prefix identifying your environment. Used with customer code and project code for unique identifier when used outside foundations"
    default     = ""
}

#Customer code used with environment code and project code to create a unique identifier when used outside foundations. For buckets, only part of the tag strategy
variable "customer_code" {
    type        = string
    description = "Small prefix indentifying the customer. Used with environment code and project code for unique identifier when used outside foundations"
    default     = ""
}

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. NOTE: For S3, this will be part of the tag, but not the actual bucket name"
}

#All other vars for the module
variable "bucket_name" {
    type        = string
    description = "The name of the bucket"
}

variable "block_public_acls" {
    description = "Whether Amazon S3 should block public ACLs for this bucket."
    type        = bool
    default     = false
}

variable "block_public_policy" {
    description = "Whether Amazon S3 should block public bucket policies for this bucket."
    type        = bool
    default     = false
}

variable "ignore_public_acls" {
    description = "Whether Amazon S3 should ignore public ACLs for this bucket."
    type        = bool
    default     = false
}

variable "policy" {
    description = "Bucket policy JSON document"
    type        = string
    default     = null
}

variable "restrict_public_buckets" {
    description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
    type        = bool
    default     = false
}

variable "server_side_encryption_configuration" {
    description = "Map containing server-side encryption configuration. Default is no encryption"
    type        = any
    default     = {}
}

variable "tags" {
    description = "Optional map of additional tags for the S3 bucket"
    type        = map(string)
    default     = {}
}