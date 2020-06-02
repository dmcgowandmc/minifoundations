###############################################################################################
## All variables for creation of vpc's, subnets, and other supporting components reside here ##
###############################################################################################

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources"
}

#All other variables for the module
variable "azs" {
    type        = list(string)
    description = "List of availability zones for VPC to apply across (WARNING: Number of public / private / data subnets must be equal to or greater than azs list)"
}

variable "cidr" {
    type        = string
    description = "CIDR Range of the VPC"
}

variable "database_subnets" {
    type        = list(string)
    description = "List of database subnet CIDRs (WARNING: Must be equal to or greated than azs)"
}

variable "private_subnets" {
    type        = list(string)
    description = "List of private subnet CIDRs (WARNING: Must be equal to or greated than azs)"
}

variable "public_subnets" {
    type        = list(string)
    description = "List of public subnet CIDRs (WARNING: Must be equal to or greated than azs)"
}

variable "name" {
    type        = string
    description = "Name of the VPC and it's supporting components"
}