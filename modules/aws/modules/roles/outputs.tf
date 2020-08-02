#########################################################
## All outputs from the creation of roles defined here ##
#########################################################

output "role_arn" {
    description = "ARN of the role"
    value       = module.iam_assumable_role.this_iam_role_arn
}

output "role_name" {
    description = "Name of the role"
    value       = module.iam_assumable_role.this_iam_role_name
}