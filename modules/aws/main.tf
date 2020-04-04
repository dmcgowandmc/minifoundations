#############################################################################
## All base code should reside here. Modules should be used where possible ##
#############################################################################

#Create admin group
module "admin_group" {
    source = "./modules/groups"

    project_code           = var.project_code
    name                   = var.group_admin_name
    self_management_policy = var.group_admin_self_management_policy
    policy_arns            = var.group_admin_policy_arns
}

#Create infra group
module "infra_group" {
    source = "./modules/groups"

    project_code           = var.project_code
    name                   = var.group_infra_name
    self_management_policy = var.group_infra_self_management_policy
    policy_arns            = var.group_infra_policy_arns
}

#Create infra role (for use by CICD)
module "infra_role" {
    source = "./modules/roles"

    project_code     = var.project_code
    name             = var.role_infra_name
    policy_arns      = var.role_infra_policy_arns
    trusted_services = var.role_infra_trusted_services
}

#Create app role (for use by CICD)
module "app_role" {
    source = "./modules/roles"

    project_code     = var.project_code
    name             = var.role_app_name
    policy_arns      = var.role_app_policy_arns
    trusted_services = var.role_app_trusted_services
}
