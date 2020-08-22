#############################################################
## All variables for creation of config rules resides here ##
#############################################################

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources"
}

#All other vars for the module
variable "name" {
    type        = string
    description = "Name of the config rule"
}

variable "audit_bucket_id" {
    type        = string
    description = "ID of the bucket that will store config rule violations"
}

variable "cr_rule" {
    type        = string
    description = "Name of the AWS provided config rule"
}

variable "crr_role_name" {
    type        = string
    description = "Name of the config rule recorder role"
}
