#######################################################
## All variables for creation of groups resides here ##
#######################################################

variable "name" {
    type        = string
    description = "Name of the group"
}

variable "users" {
    type        = list(string)
    description = "List of users to add to group. This can be ignored if desired"
    default     = []
}

variable "self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this group our allowed to manage there passwords and 2FA"
}

variable "policy_arns" {
    type        = list(string)
    description = "List of ARNs already defined to attach to this group. This can be ignored if desired"
    default     = []
}

variable "policies" {
    type        = list(map(string))
    description = "List of objects. Object should contain a 'name' and a 'policy' with a reference to a valid json file. This can be ignored if desired"
    default     = []
}