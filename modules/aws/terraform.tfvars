#################################################################################
## If running this directly and not using as a module, values are defined here ##
#################################################################################

#Inputs for Groups
group_admin_name                   = "administrators"
group_admin_self_management_policy = true
group_admin_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
]

group_infra_name                   = "devops"
group_infra_self_management_policy = true
group_infra_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
]

#Inputs for Roles
role_infra_name = "devops"
role_infra_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
]
role_infra_trusted_services = [
    "codebuild.amazonaws.com"
]

role_app_name = "fullstack"
#role_infra_policy_arns = [] #Permissions to be defined
role_app_trusted_services = [
    "codebuild.amazonaws.com"
]