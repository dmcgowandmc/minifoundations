######################################################
## All variables for creation of roles resides here ##
######################################################

variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

variable "name" {
    type        = string
    description = "Name of the role"
}

variable "users" {
    type        = list(string)
    description = "List of users to add to role. This can be ignored if desired"
    default     = []
}

variable "policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this role. This can be ignored if desired"
    default     = []
}

variable "trusted_services" {
    type        = list(string)
    description = "List of trusted services that can assum this role. At least one value is required"
}
