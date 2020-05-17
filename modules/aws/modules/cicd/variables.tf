############################################################################################
## All variables for the CICD pipeline using code commit, build and pipeline defined here ##
############################################################################################

variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

variable "artefact_bucket_name" {
    type        = string
    description = "Name of the bucket where artefacts will be stored"
}

variable "cp_name" {
    type        = string
    description = "Name of the Code Pipeline"
}

variable "cp_description" {
    type        = string
    description = "Description of the Code Pipeline"
}

variable "cb_name" {
    type        = string
    description = "Name of the Code Build Project"
}

variable "cb_description" {
    type        = string
    description = "Description of the Code Build Project"
}

variable "cp_role_arn" {
    type        = string
    description = "The ARN of the role CodePipeline will use"
}

variable "cp_repo_name" {
    type        = string
    description = "Name of the repository CodePipeline stage one will read from"
}

variable "cp_repo_owner" {
    type        = string
    description = "Owner of the repository CodePipeline state one will read from"
}

variable "cp_repo_oauthtoken" {
    type        = string
    description = "Oauth token for authorized access to repo (only GitLab supported at this time)"
}