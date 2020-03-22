#############################################################################
## All base code should reside here. Modules should be used where possible ##
#############################################################################

module "admin_group" {
    source = "./modules/groups"

    name                   = var.group_name
    self_management_policy = var.group_self_management_policy
    policy_arns            = var.group_policy_arns
}