#######################################################################
## All code specifically for the creation of s3 buckets resides here ##
#######################################################################

locals {
    #Resource code NOTE: Resource and project code will only be used for tags
    role_resource_code = "r"
}

#Buckets name should not reveal there associated projects, so using a random prefix to prevent conflits with other buckets instead of project code
resource "random_id" "bucket_prefix" {
    keepers = {
        #We add variables where change forces a re-create
        bucket_name_base64 = base64encode(var.bucket_name)
    }

    byte_length = 2
}

#Actually create the s3 bucket. With the exception of the bucket name, this module should be as similar to the aws s3-bucket as possible
module "s3_bucket" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "~> 1.0"

    block_public_acls                    = var.block_public_acls
    block_public_policy                  = var.block_public_policy
    bucket                               = "${random_id.bucket_prefix.hex}-${var.bucket_name}"
    ignore_public_acls                   = var.ignore_public_acls
    restrict_public_buckets              = var.restrict_public_buckets
    server_side_encryption_configuration = var.server_side_encryption_configuration
}
