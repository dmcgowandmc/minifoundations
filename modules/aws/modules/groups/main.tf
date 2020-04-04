###############################################################
## All code specifically for creation of groups resides here ##
###############################################################

#Use standard AWS module to create IAM Group with policies
module "iam_group_with_policies" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
    version = "~> 2.0"

    name                              = "${var.project_code}-${var.name}"
    group_users                       = var.users
    attach_iam_self_management_policy = var.self_management_policy
    custom_group_policy_arns          = var.policy_arns
    custom_group_policies             = var.policies
}