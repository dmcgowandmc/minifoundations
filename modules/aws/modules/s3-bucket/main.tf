#######################################################################
## All code specifically for the creation of s3 buckets resides here ##
#######################################################################

locals {
    #Resource code NOTE: Resource, project code, customer code and environment code will only be used for tags
    s3_resource_code = "s3"
    tag_name = var.customer_code != "" && var.environment_code != "" ? "${var.project_code}-${local.s3_resource_code}-${var.customer_code}-${var.environment_code}-${var.bucket_name}" : "${var.project_code}-${local.s3_resource_code}-${var.bucket_name}"
    tags = merge(
        {
            "Name"             = local.tag_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.s3_resource_code,
            "Customer Code"    = var.customer_code == "" ? "NA" : var.customer_code,
            "Environment Code" = var.environment_code == "" ? "NA" : var.environment_code
        },
        var.tags
    )
}

#Buckets name should not reveal there associated projects, so using a random postfix to prevent conflits with other buckets instead of project code
resource "random_id" "bucket_postfix" {
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
    bucket                               = "${var.bucket_name}-${random_id.bucket_postfix.hex}"
    ignore_public_acls                   = var.ignore_public_acls
    policy                               = var.policy
    restrict_public_buckets              = var.restrict_public_buckets
    server_side_encryption_configuration = var.server_side_encryption_configuration
    tags                                 = local.tags
}
