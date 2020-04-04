#######################################################################
## All code specifically for the creation of s3 buckets resides here ##
#######################################################################

#Buckets name should not reveal there associated projects, so using a random prefix to prevent conflits with other buckets
resource "random_id" "bucket_prefix" {
    keepers = {
        #We add variables where change forces a re-create
        bucket_base64 = base64encode(var.bucket_name)
    }

    byte_length = 2
}

module "s3_bucket" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "~> 1.0"

    bucket                               = "${random_id.bucket_prefix.hex}-${var.bucket_name}"
    block_public_acls                    = var.block_public_acls
    ignore_public_acls                   = var.ignore_public_acls
    block_public_policy                  = var.block_public_policy
    restrict_public_buckets              = var.restrict_public_buckets
    server_side_encryption_configuration = var.server_side_encryption_configuration
}