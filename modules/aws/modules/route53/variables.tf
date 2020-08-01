###############################################################
## All variables for creation of route 53 zones resides here ##
###############################################################

#Environment code used with customer code and project code to create a unique identifier when used outside foundations. For route53, only part of the tag strategy
variable "environment_code" {
    type        = string
    description = "2 - 4 letter prefix identifying your environment. Used with customer code and project code for unique identifier when used outside foundations"
    default     = ""
}

#Customer code used with environment code and project code to create a unique identifier when used outside foundations. For route53, only part of the tag strategy
variable "customer_code" {
    type        = string
    description = "Small prefix indentifying the customer. Used with environment code and project code for unique identifier when used outside foundations"
    default     = ""
}

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

#All other vars for the module
variable "child_zone_map" {
    type        = map
    description = "A map of of child zone names and there corresponding NS records. (we use a map so multiple child zones can be added if desired)"
    default     = {}
}

variable "force_destory" {
    type        = bool
    description = "Set to true to force this zone to be destroyed along with records where a destroy and recreate is required"
    default     = true
}

variable "tags" {
    description = "Optional map of additional tags for the route53 zone"
    type        = map(string)
    default     = {}
}

variable "vpc_id" {
    type        = string
    description = "ID of the VPC to associate this zone to (only applicable to private zones)"
    default     = ""
}

variable "zone_fqdn" {
    type        = string
    description = "Fully qualified domain name for the zone"
}
