#################################################################################
## If running this directly and not using as a module, values are defined here ##
#################################################################################

group_name                   = "administrators"
group_self_management_policy = true
group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
]