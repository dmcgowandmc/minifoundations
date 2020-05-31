#################################################################################
## If running this directly and not using as a module, values are defined here ##
#################################################################################

#Inputs for CloudTrail long term storage
ct_bucket_name = "platformtrail"

#Inputs for admin group
group_admin_name        = "administrators"
group_admin_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
]
group_admin_self_management_policy = true


#Inputs for infra group
group_infra_name        = "devops"
group_infra_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
    "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AWSCloudTrailFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
]
group_infra_self_management_policy = true


#Inputs for infra role
role_infra_name        = "devops"
role_infra_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
    "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AWSCloudTrailFullAccess"
]
role_infra_trusted_services = [
    "codebuild.amazonaws.com",
    "codepipeline.amazonaws.com"
]

#Inputs for fullstack role
role_app_name = "fullstack"
#role_app_policy_arns = [] #Permissions to be defined
role_app_trusted_services = [
    "codebuild.amazonaws.com"
]

#Inputs for common CICD components
cp_bucket_name   = "artefacts"
github_owner     = "dmcgowandmc"
ssm_github_token = "github_token"

#Inputs for all foundations CICD components
cb_foundations_description = "Foundations CodeBuild"
cb_foundations_name        = "foundations"
cp_foundations_description = "Foundations Pipeline"
cp_foundations_name        = "foundations"
github_foundations_name    = "minifoundations"
github_foundations_path    = "https://github.com/dmcgowandmc/minifoundations.git"
