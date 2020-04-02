#####################################################
## All variable s for base code should reside here ##
#####################################################

variable "region" {
    type        = string
    description = "The region your resources will reside in"
}

variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

variable "group_name" {
    type        = string
    description = "Name of the group"
}

variable "group_self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this group our allowed to manage there passwords and 2FA"
}

variable "group_policy_arns" {
    type        = list(string)
    description = "List of ARNs already defined to attach to this group. Must be defined"
}
