#############################################################################
## All base code should reside here. Modules should be used where possible ##
#############################################################################

#Get details of account calling these operations
data "aws_caller_identity" "this" {}

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

resource "aws_ssm_parameter" "infra_role_arn" {
    name  = "infrarolearn"
    type  = "String"
    value = module.infra_role.role_arn
}

#Create bucket for long term storage of logs for auditing
module "audit_s3_bucket" {
    source = "./modules/s3-bucket"

    block_public_acls                    = true
    block_public_policy                  = true
    project_code                         = var.project_code
    bucket_name                          = var.audit_bucket_name
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

#Create a bucket policy for long term stroage s3 bucket. Basically we want to prevent accidental or intentional deletion of data
#Create the policy
data "template_file" "audit_s3_bucket_policy_json" {
    template = file("policies/audit-s3-bucket-policy.json.tpl")

    vars = {
        s3_bucket_arn = module.audit_s3_bucket.s3_bucket_arn
        account_id    = data.aws_caller_identity.this.account_id
    }
}

#Apply the policy
resource "aws_s3_bucket_policy" "audit_s3_bucket_policy" {
    bucket = module.audit_s3_bucket.s3_bucket_id

    policy = data.template_file.audit_s3_bucket_policy_json.rendered
}

#Create the management level cloud trail (limited benefit turning this into a module for now)
resource "aws_cloudtrail" "accesstrail" {
    name                          = "${var.project_code}-ct-accesstrail"
    s3_bucket_name                = module.audit_s3_bucket.s3_bucket_id
    include_global_service_events = false
}

#Create admin group
module "admin_group" {
    source = "./modules/groups"

    name                   = var.group_admin_name
    policy_arns            = var.group_admin_policy_arns
    project_code           = var.project_code
    self_management_policy = var.group_admin_self_management_policy
}

#Create infra group (for DevOps engineers)
module "infra_group" {
    source = "./modules/groups"

    name                   = var.group_infra_name
    policy_arns            = var.group_infra_policy_arns
    project_code           = var.project_code
    self_management_policy = var.group_infra_self_management_policy
}

#Create infra role (for use by CICD for foundations and infra deployments)
module "infra_role" {
    source = "./modules/roles"

    name             = var.role_infra_name
    policy_arns      = var.role_infra_policy_arns
    project_code     = var.project_code
    trusted_services = var.role_infra_trusted_services
}

#Create app role (for use by CICD for application deployments)
module "app_role" {
    source = "./modules/roles"

    name             = var.role_app_name
    policy_arns      = var.role_app_policy_arns
    project_code     = var.project_code
    trusted_services = var.role_app_trusted_services
}

#Create VPC for the platform
module "vpc_foundations" {
    source = "./modules/vpc"

    azs              = var.vpc_foundations_azs
    cidr             = var.vpc_foundations_cidr
    database_subnets = var.vpc_foundations_database_subnets
    private_subnets  = var.vpc_foundations_private_subnets
    public_subnets   = var.vpc_foundations_public_subnets
    name             = var.vpc_foundations_name
    project_code     = var.project_code
}

#Create a private Route 53 zone for the VPC
module "private_route53" {
    source = "./modules/route53"

    project_code = var.project_code
    vpc_id       = module.vpc_foundations.vpc_id
    zone_fqdn    = var.internal_zone_fqdn
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

#Create UAT CICD for the foundations repo
#NOTE: As there actually isn't a concept of environments at the foundations, UAT CICD will produce a plan only
module "cicd_foundations_master" {
    source = "./modules/cicd"

    artefact_bucket_name = module.cp_s3_bucket.s3_bucket_id
    cb_buildspec_path    = var.cb_foundations_buildspec_path
    cb_description       = var.cb_foundations_description
    cb_name              = var.cb_foundations_name
    cp_description       = var.cp_foundations_description
    cp_name              = var.cp_foundations_name
    environment_code     = "uat"
    github_branch        = "master"
    github_name          = var.github_foundations_name
    github_path          = var.github_foundations_path
    github_owner         = var.github_owner
    project_code         = var.project_code
    role_name             = module.infra_role.role_name
    ssm_github_token     = var.ssm_github_token
}

#Create Production CICD for the foundations repo
#NOTE: Will produce a plan and apply as per other stacks
module "cicd_foundations_production" {
    source = "./modules/cicd"

    artefact_bucket_name = module.cp_s3_bucket.s3_bucket_id
    cb_buildspec_path    = var.cb_foundations_buildspec_path
    cb_description       = var.cb_foundations_description
    cb_name              = var.cb_foundations_name
    cp_description       = var.cp_foundations_description
    cp_name              = var.cp_foundations_name
    environment_code     = "prod"
    github_branch        = "production"   
    github_name          = var.github_foundations_name
    github_path          = var.github_foundations_path
    github_owner         = var.github_owner
    project_code         = var.project_code
    role_name             = module.infra_role.role_name
    ssm_github_token     = var.ssm_github_token
}

#Create UAT CICD for services built ontop of foundations
module "cicd_services_master" {
    source = "./modules/cicd"

    artefact_bucket_name = module.cp_s3_bucket.s3_bucket_id
    cb_description       = var.cb_services_description
    cb_name              = var.cb_services_name
    cp_description       = var.cp_services_description
    cp_name              = var.cp_services_name
    environment_code     = "uat"
    github_branch        = "master"
    github_name          = var.github_services_name
    github_path          = var.github_services_path
    github_owner         = var.github_owner
    project_code         = var.project_code
    role_name             = module.infra_role.role_name
    ssm_github_token     = var.ssm_github_token
}

#Create UAT CICD for services built ontop of foundations
module "cicd_services_production" {
    source = "./modules/cicd"

    artefact_bucket_name = module.cp_s3_bucket.s3_bucket_id
    cb_description       = var.cb_services_description
    cb_name              = var.cb_services_name
    cp_description       = var.cp_services_description
    cp_name              = var.cp_services_name
    environment_code     = "prod"
    github_branch        = "production"
    github_name          = var.github_services_name
    github_path          = var.github_services_path
    github_owner         = var.github_owner
    project_code         = var.project_code
    role_name             = module.infra_role.role_name
    ssm_github_token     = var.ssm_github_token
}
