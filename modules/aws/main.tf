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

#Create storage bucket for CodePipeline
module "cp_s3_bucket" {
    source = "./modules/s3-bucket"

    bucket_name = var.cp_bucket_name

    server_side_encryption_configuration = {
        rule = {
            apply_server_side_encryption_by_default = {
                sse_algorithm     = "AES256"
            }
        }
    }

    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
}

#Create CICD for the foundations repo
module "cicd_foundations" {
    source = "./modules/cicd"

    project_code         = var.project_code
    artefact_bucket_name = module.cp_s3_bucket.s3_bucket_id
    cp_name              = var.cp_foundations_name
    cp_description       = var.cp_foundations_desc
    cp_role_arn          = module.infra_role.role_arn
    cp_repo_name         = var.cp_foundations_repo_name
    cp_repo_owner        = var.cp_foundations_repo_owner
    cp_repo_oauthtoken   = var.cp_foundations_repo_oauthtoken
    cb_name              = var.cb_foundations_name    
    cb_description       = var.cb_foundations_description
}
