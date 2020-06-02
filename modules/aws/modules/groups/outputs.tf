##########################################################
## All outputs from the creation of groups defined here ##
##########################################################

output "group_name" {
    description = "Name of the group"
    value       = module.iam_group_with_policies.this_group_name
}
