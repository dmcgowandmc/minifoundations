################################################################
## All code specifically for the creation of sns resides here ##
################################################################

locals {
    #Resource code
    s3_resource_code = "sns"

    #Tag Settings
    sns_name = var.customer_code != "" && var.environment_code != "" ? "${var.project_code}-${local.s3_resource_code}-${var.customer_code}-${var.environment_code}-${var.sns_name}" : "${var.project_code}-${local.s3_resource_code}-${var.sns_name}"
    tags = merge(
        {
            "Name"             = local.sns_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.s3_resource_code,
            "Customer Code"    = var.customer_code == "" ? "NA" : var.customer_code,
            "Environment Code" = var.environment_code == "" ? "NA" : var.environment_code
        },
        var.tags
    )
}

module "sns_topic" {
    source  = "terraform-aws-modules/sns/aws"
    version = "~> 2.0"
    
    name = local.sns_name
    tags = local.tags

    #Additional features will be enabled once need arises
}
