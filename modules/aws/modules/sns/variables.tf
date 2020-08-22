####################################################
## All variables for creation of sns resides here ##
####################################################

#Environment code used with customer code and project code to create a unique identifier when used outside foundations
variable "environment_code" {
    type        = string
    description = "2 - 4 letter prefix identifying your environment. Used with customer code and project code for unique identifier when used outside foundations"
    default     = ""
}

#Customer code used with environment code and project code to create a unique identifier when used outside foundations
variable "customer_code" {
    type        = string
    description = "Small prefix indentifying the customer. Used with environment code and project code for unique identifier when used outside foundations"
    default     = ""
}

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources"
}

#All other vars for the module
variable "sns_name" {
    type        = string
    description = "Name of the SNS topic"
}

variable "tags" {
    description = "Optional map of additional tags for the sns topic"
    type        = map(string)
    default     = {}
}