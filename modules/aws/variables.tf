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

variable "group_admin_name" {
    type        = string
    description = "Name of the the admin group"
}

variable "group_admin_self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this admin group our allowed to manage there passwords and 2FA"
}

variable "group_admin_policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this admin group. Must be defined"
}

variable "group_infra_name" {
    type        = string
    description = "Name of the the infra group"
}

variable "group_infra_self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this infra group our allowed to manage there passwords and 2FA"
}

variable "group_infra_policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this infra group. Must be defined"
}
