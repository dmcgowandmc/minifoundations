############################################################
## All variables for cloudfront distribution defined here ##
############################################################

#Environment code used with customer code and project code to create a unique identifier
variable "environment_code" {
    type        = string
    description = "2 - 4 letter prefix identifying your environment. Used with customer code and project code for unique name"
}

#Customer code used with environment code and project code to create a unique name
variable "customer_code" {
    type        = string
    description = "Small prefix indentifying the customer. Used with environment code and project code for unique name"
}

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

#All other variables for the module
variable "cf_default_root_object" {
    type        = string
    description = "Default root object for cloudfront distribution to refer to"
    default     = "index.html"
}

variable "cf_distribution_description" {
    type        = string
    description = "CloudFront distribution description keyword"
}

variable "cf_s3_audit_bucket_regional_domain_name" {
    type        = string
    description = "S3 bucket regional domain name to store cloudfront logs for auditing purposes"
}

variable "cf_s3_origin_bucket_id" {
    type        = string
    description = "S3 bucket ID that will be the origin for static content"
}

variable "cf_s3_origin_bucket_arn" {
    type        = string
    description = "S3 bucket ARN that will be the origin for static content"
}

variable "cf_s3_origin_bucket_regional_domain_name" {
    type        = string
    description = "S3 bucket regional domain name that will be the origin for static content"
}

variable "cf_s3_origin_id" {
    type        = string
    description = "Unique identifier for origin that will be used for the static content origin"
}

variable "r53_fqdn" {
    type        = string
    description = "Valid route 53 FQDN"
}

variable "r53_aliases" {
    type        = list(string)
    description = "A list of aliases (subdomains) in addition to the r53_fqdn (can be empty). Just provide the alias keyword and the full FQDN will be assembled for you"
    default     = []
}

variable "r53_zone_id" {
    type        = string
    description = "Valid route 53 zone ID. r53_fqdn + r53_aliases will be added to the zone as alias records for Cloud Front"
}

variable "tags" {
    description = "Optional map of additional tags for cloudfront"
    type        = map(string)
    default     = {}
}