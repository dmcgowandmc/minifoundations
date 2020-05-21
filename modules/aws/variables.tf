####################################################
## All variables for base code should reside here ##
####################################################

variable "region" {
    type        = string
    description = "The region your resources will reside in"
}

variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

variable "group_admin_name" {
    type        = string
    description = "Name of the the admin group"
}

variable "group_admin_self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this admin group our allowed to manage there passwords and 2FA"
}

variable "group_admin_policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this admin group. Must be defined"
    default     = []
}

variable "group_infra_name" {
    type        = string
    description = "Name of the the infra group"
}

variable "group_infra_self_management_policy" {
    type        = bool
    description = "Flag to indicate if members of this infra group our allowed to manage there passwords and 2FA"
}

variable "group_infra_policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this infra group. Must be defined"
    default     = []
}

variable "role_infra_name" {
    type        = string
    description = "Name of the infra role"
}

variable "role_infra_policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this infra role. Must be defined"
    default     = []
}

variable "role_infra_trusted_services" {
    type        = list(string)
    description = "List of trusted services that can use this role"
}

variable "role_app_name" {
    type        = string
    description = "Name of the infra role"
}

variable "role_app_policy_arns" {
    type        = list(string)
    description = "List of ARNs to attach to this infra role. Must be defined"
    default     = []
}

variable "role_app_trusted_services" {
    type        = list(string)
    description = "List of trusted services that can use this role"
}

variable "ssm_github_token" {
    type        = string
    description = "Name of the SSM parameter store that will contain your GitHub token (only GitLab supported at this time)"
}

variable "cp_bucket_name" {
    type        = string
    description = "Name of s3 bucket for CodePipeline artefacts"
}

variable "cp_foundations_name" {
    type        = string
    description = "Name of the CodePipeline for foundations"
}

variable "cp_foundations_desc" {
    type        = string
    description = "Description of the CodePipeline for foundations"
}

variable "github_foundations_name" {
    type        = string
    description = "Name of the foundations GitHub repo"
}

variable "github_foundations_path" {
    type        = string
    description = "Path to the foundations GitHub repo"
}

variable "github_foundations_owner" {
    type        = string
    description = "Owner of the GitHub foundations repository"
}

variable "cb_foundations_name" {
    type        = string
    description = "Name of the foundations Code Build Project"
}

variable "cb_foundations_description" {
    type        = string
    description = "Description of the foundations Code Build Project"
}