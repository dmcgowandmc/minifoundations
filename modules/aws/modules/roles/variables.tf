######################################################
## All variables for creation of roles resides here ##
######################################################

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
    description = "Name of the role"
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

variable "users" {
    type        = list(string)
    description = "List of users to add to role. This can be ignored if desired"
    default     = []
}

variable "tags" {
    type        = map(string)
    description = "Optional map of additional tags for the role"
    default     = {}
}
