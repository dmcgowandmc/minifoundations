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
    description = "Name of the Code Commit Repository"
}

variable "cp_description" {
    type        = string
    description = "Description of the Code Commit Repository"
}

variable "cp_role_arn" {
    type        = string
    description = "The ARN of the role CodePipeline will use"
}

variable "cp_repo" {
    type        = string
    description = "Name of the repository CodePipeline stage one will read from"
}

variable "gitlab_name"
variable "gitlab_oauthtoken" {
    type        = string
    description = "Oauth token for authorized access to GitLab repo (only GitLab supported at this time)"
}