##################################################################
## All code specifically for the creation of roles resides here ##
##################################################################

locals {
    #Resource code
    role_resource_code = "r"
}

module "iam_assumable_role" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version = "~> 2.0"

    create_role             = true
    custom_role_policy_arns = var.policy_arns
    role_name               = "${var.project_code}-${local.role_resource_code}-${var.name}"
    role_requires_mfa       = false
    trusted_role_services   = var.trusted_services
}
