#############################################################
## All variables for creation of config rules resides here ##
#############################################################

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources"
}

#All other vars for the module
variable "audit_bucket_id" {
    type        = string
    description = "ID of the bucket that will store config rule violations"
}

variable "cr_rules" {
    type        = map(any) #Not ideal
    description = "A map specifying the desired rule and any required inputs"
    default     = {"ROOT_ACCOUNT_MFA_ENABLED" = {}}
}

variable "crr_role_name" {
    type        = string
    description = "Name of the config rule recorder role"
}

variable "sns_critical_arn" {
    type        = string
    description = "The ARN of the SNS topic used for critical alerts"
}