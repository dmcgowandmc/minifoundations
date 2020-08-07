##################################################################
## All code specifically for the creation of roles resides here ##
##################################################################

locals {
    #Resource code
    role_resource_code = "r"

    #Name and Tag Settings
    role_name = var.customer_code == "" && var.environment_code == "" ? "${var.project_code}-${local.role_resource_code}-${var.name}" : var.environment_code == "" ? "${var.project_code}-${local.role_resource_code}-${var.customer_code}-${var.name}" : "${var.project_code}-${local.role_resource_code}-${var.customer_code}-${var.environment_code}-${var.name}"
    tags = merge(
        {
            "Name"             = local.role_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.role_resource_code,
            "Customer Code"    = var.customer_code == "" ? "NA" : var.customer_code,
            "Environment Code" = var.environment_code == "" ? "NA" : var.environment_code
        },
        var.tags
    )
}

#Create role
module "iam_assumable_role" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version = "~> 2.0"

    create_role             = true
    custom_role_policy_arns = var.policy_arns
    role_name               = local.role_name
    role_requires_mfa       = false
    trusted_role_services   = var.trusted_services
    tags                    = local.tags
}
