#################################################################################
## If running this directly and not using as a module, values are defined here ##
#################################################################################

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