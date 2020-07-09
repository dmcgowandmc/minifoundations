############################################################################################
## All variables for the CICD pipeline using code commit, build and pipeline defined here ##
############################################################################################

#Project code forms part of the naming convention
variable "project_code" {
    type        = string
    description = "Three letter prefix to identity your resources. All resources will be prefixed with this code"
}

#All other vars for the module
variable "artefact_bucket_name" {
    type        = string
    description = "Name of the bucket where artefacts will be stored"
}

variable "cb_buildspec_path" {
    type        = string
    description = "Path to the buildspec file where not in default root location"
    default     = ""
}

variable "cb_description" {
    type        = string
    description = "Description of the Code Build Project"
}

variable "cb_name" {
    type        = string
    description = "Name of the Code Build Project"
}

variable "cp_description" {
    type        = string
    description = "Description of the Code Pipeline"
}

variable "cp_name" {
    type        = string
    description = "Name of the Code Pipeline"
}

variable "cp_role_arn" {
    type        = string
    description = "The ARN of the role CodePipeline will use"
}

##PLACEHOLDER
##I may experiment with gitops and gitflow style pipelines. However in the short term, i think just using gitops for all deployments is the way to go
##This gives app developers the ability to control deployments within Git 

variable "github_name" {
    type        = string
    description = "Name of the GitHub repo"
}

variable "github_owner" {
    type        = string
    description = "Owner of the GitHub repository"
}

variable "github_path" {
    type        = string
    description = "Path to the GitHub repo"
}

variable "ssm_github_token" {
    type        = string
    description = "Name of the SSM parameter store that will contain your GitHub token (only GitLab supported at this time)"
}
