###############################################################
## All variables for creation of route 53 zones resides here ##
###############################################################

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

#All other vars for the module
variable "force_destory" {
    type        = bool
    description = "Set to true to force this zone to be destroyed along with records where a destroy and recreate is required"
    default     = true
}

variable "vpc_id" {
    type        = string
    description = "ID of the VPC to associate this zone to (only applicable to private zones)"
    default     = ""
}

variable "zone_fqdn" {
    type        = string
    description = "Fully qualified domain name for the new zone"
}
