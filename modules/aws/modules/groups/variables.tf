#######################################################
## All variables for creation of groups resides here ##
#######################################################

#Environment code used with customer code and project code to create a unique identifier
variable "environment_code" {
    type        = string
    description = "2 - 4 letter prefix identifying your environment. Used with customer code and project code for unique name when used outside foundations"
    default     = ""
}

#Customer code used with environment code and project code to create a unique name
variable "customer_code" {
    type        = string
    description = "Small prefix indentifying the customer. Used with environment code and project code for unique name when used outside foundations"
    default     = ""
}

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

#All other vars for the module
variable "name" {
    type        = string
    description = "Name of the group"
}

variable "policies" {
    type        = list(map(string))
    description = "List of objects. Object should contain a 'name' and a 'policy' with a reference to a valid json file. This can be ignored if desired"
    default     = []
}

variable "policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this group. This can be ignored if desired"
    default     = []
}

variable "self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this group our allowed to manage there passwords and 2FA"
}

variable "users" {
    type        = list(string)
    description = "List of users to add to group. This can be ignored if desired"
    default     = []
}
