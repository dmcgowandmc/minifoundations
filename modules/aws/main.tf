#############################################################################
## All base code should reside here. Modules should be used where possible ##
#############################################################################

#Add global inputs to SSM. So they can be referenced by CodeBuild 
resource "aws_ssm_parameter" "projectcode" {
    name  = "projectcode"
    type  = "String"
    value = var.project_code
}

resource "aws_ssm_parameter" "region" {
    name  = "region"
    type  = "String"
    value = var.region
}

resource "aws_ssm_parameter" "statebucket" {
    name  = "statebucket"
    type  = "String"
    value = var.statebucket
}

#Create admin group
module "admin_group" {
    source = "./modules/groups"

    name                   = var.group_admin_name
    policy_arns            = var.group_admin_policy_arns
    project_code           = var.project_code
    self_management_policy = var.group_admin_self_management_policy
}

#Create infra group
module "infra_group" {
    source = "./modules/groups"

    name                   = var.group_infra_name
    policy_arns            = var.group_infra_policy_arns
    project_code           = var.project_code
    self_management_policy = var.group_infra_self_management_policy
}

#Create infra role (for use by CICD)
module "infra_role" {
    source = "./modules/roles"

    name             = var.role_infra_name
    policy_arns      = var.role_infra_policy_arns
    project_code     = var.project_code
    trusted_services = var.role_infra_trusted_services
}

#Create app role (for use by CICD)
module "app_role" {
    source = "./modules/roles"

    name             = var.role_app_name
    policy_arns      = var.role_app_policy_arns
    project_code     = var.project_code
    trusted_services = var.role_app_trusted_services
}

#Create storage bucket for CodePipeline
module "cp_s3_bucket" {
    source = "./modules/s3-bucket"

    block_public_acls                    = true
    block_public_policy                  = true
    project_code                         = var.project_code
    bucket_name                          = var.cp_bucket_name
    ignore_public_acls                   = true
    restrict_public_buckets              = true
    server_side_encryption_configuration = {
        rule = {
            apply_server_side_encryption_by_default = {
                sse_algorithm     = "AES256"
            }
        }
    }
}

#Create CICD for the foundations repo
module "cicd_foundations" {
    source = "./modules/cicd"

    artefact_bucket_name = module.cp_s3_bucket.s3_bucket_id
    cb_description       = var.cb_foundations_description
    cb_name              = var.cb_foundations_name
    cp_description       = var.cp_foundations_description
    cp_name              = var.cp_foundations_name
    cp_role_arn          = module.infra_role.role_arn    
    github_name         = var.github_foundations_name
    github_path         = var.github_foundations_path
    github_owner        = var.github_owner
    project_code         = var.project_code
    ssm_github_token     = var.ssm_github_token
}
