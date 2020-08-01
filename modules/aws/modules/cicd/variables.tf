############################################################################################
## All variables for the CICD pipeline using code commit, build and pipeline defined here ##
############################################################################################

#Environment code used with customer code and project code to create a unique identifier. Always used for CICD as there must be 2 environments at minimum
variable "environment_code" {
    type        = string
    description = "2 - 4 letter prefix identifying your environment. Required for CICD"
}

#Customer code used with environment code and project code to create a unique name
variable "customer_code" {
    type        = string
    description = "Small prefix indentifying the customer. Used with environment code and project code for unique name when used outside foundations"
    default     = ""
}

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

variable "cb_buildspec_cmd" {
    type        = object({ cmd = string, var = map(string) })
    description = "A map specifying the desired command and any required inputs. If left to default, it will be ignored and a buildspec file will be expected in repo"
    default     = {"cmd" = "NA", "var" = {}}
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

variable "github_branch" {
    type        = string
    description = "The branch for the CICD to work off"
}
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

variable "tags" {
    type        = map(string)
    description = "Optional map of additional tags for code build and code pipeline (added to both)"
    default     = {}
}