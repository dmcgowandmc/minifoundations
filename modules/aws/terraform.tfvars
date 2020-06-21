#################################################################################
## If running this directly and not using as a module, values are defined here ##
#################################################################################

#Inputs for CloudTrail long term storage
ct_bucket_name = "platformtrail"

#Inputs for admin group
group_admin_name        = "administrators"
group_admin_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
]
group_admin_self_management_policy = true


#Inputs for infra group
group_infra_name        = "devops"
group_infra_policy_arns = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/PowerUserAccess"
]
group_infra_self_management_policy = true


#Inputs for infra role
role_infra_name        = "devops"
role_infra_policy_arns = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/PowerUserAccess"
]
role_infra_trusted_services = [
    "codebuild.amazonaws.com",
    "codepipeline.amazonaws.com"
]

#Inputs for fullstack role
role_app_name = "fullstack"
#role_app_policy_arns = [] #Permissions to be defined
role_app_trusted_services = [
    "codebuild.amazonaws.com"
]

#Inputs for foundations VPC
vpc_foundations_azs              = ["ap-southeast-2a"]
vpc_foundations_cidr             = "10.0.0.0/19"
vpc_foundations_database_subnets = ["10.0.8.0/23"]
vpc_foundations_private_subnets  = ["10.0.16.0/22"]
vpc_foundations_public_subnets   = ["10.0.0.0/23"]
vpc_foundations_name             = "foundations"

#Inputs for Route 53
prod_zone_fqdn = "tst.dmcgowan.click"
uat_zone_fqdn  = "uat.tst.dmcgowan.click"

#Inputs for common CICD components
cp_bucket_name   = "artefacts"
github_owner     = "dmcgowandmc"
ssm_github_token = "github_token"

#Inputs for all foundations CICD components
cb_foundations_buildspec_path = "modules/aws/"
cb_foundations_description    = "Foundations CodeBuild"
cb_foundations_name           = "foundations"
cp_foundations_description    = "Foundations Pipeline"
cp_foundations_name           = "foundations"
github_foundations_name       = "minifoundations"
github_foundations_path       = "https://github.com/dmcgowandmc/minifoundations.git"

#Inputs for all webstack CICD components
cb_webstack_description = "Webstack CodeBuild"
cb_webstack_name        = "webstack"
cp_webstack_description = "Webstack Pipeline"
cp_webstack_name        = "webstack"
github_webstack_name    = "webstack"
github_webstack_path    = "https://github.com/dmcgowandmc/webstack.git"
