###############################################################
## All code specifically for creation of groups resides here ##
###############################################################

locals {
    #Resource code
    group_resource_code = "g"

    #Name and Tag Settings
    group_name = var.customer_code == "" && var.environment_code == "" ? "${var.project_code}-${local.group_resource_code}-${var.name}" : var.environment_code == "" ? "${var.project_code}-${local.group_resource_code}-${var.customer_code}-${var.name}" : "${var.project_code}-${local.group_resource_code}-${var.customer_code}-${var.environment_code}-${var.name}"
}

#Use standard AWS module to create IAM Group with policies
module "iam_group_with_policies" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
    version = "~> 2.0"

    attach_iam_self_management_policy = var.self_management_policy
    custom_group_policies             = var.policies
    custom_group_policy_arns          = var.policy_arns
    group_users                       = var.users
    name                              = local.group_name
}
