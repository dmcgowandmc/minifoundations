##############################################################################################
## All code for creating a CICD pipeline using code commit, build and pipeline defined here ##
##############################################################################################

#NOTE: Not happy with this design, but attempting to work around CodeBuild / CodePipelines rigid and inflexible model to implement GitOps
#Each implementation of this module will result in a 2 stage pipeline and codebuild which will target a single branch. Additional implementations of this module will be performed for each branch

locals {
    #Resource codes
    cb_resource_code = "cb"
    cp_resource_code = "cp"

    #Code Build Name and Tag Settings
    cb_name = var.customer_code == "" ? "${var.project_code}-${local.cb_resource_code}-${var.environment_code}-${var.cb_name}" : "${var.project_code}-${local.cb_resource_code}-${var.customer_code}-${var.environment_code}-${var.cb_name}"
    cb_tags = merge(
        {
            "Name"             = local.cb_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.cb_resource_code,
            "Customer Code"    = var.customer_code == "" ? "NA" : var.customer_code,
            "Environment Code" = var.environment_code
        },
        var.tags
    )

    #Code Pipeline Name and Tag Settings
    cp_name = var.customer_code == "" ? "${var.project_code}-${local.cp_resource_code}-${var.environment_code}-${var.cp_name}" : "${var.project_code}-${local.cp_resource_code}-${var.customer_code}-${var.environment_code}-${var.cp_name}"
    cp_tags = merge(
        {
            "Name"             = local.cp_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.cp_resource_code,
            "Customer Code"    = var.customer_code == "" ? "NA" : var.customer_code,
            "Environment Code" = var.environment_code
        },
        var.tags
    )
}

#Get secure token from ssm parameter store
data "aws_ssm_parameter" "ssm_github_token" {
    name = var.ssm_github_token
}

#Setting up GitHub authorization for CodeBuild
resource "aws_codebuild_source_credential" "github_auth" {
    auth_type   = "PERSONAL_ACCESS_TOKEN"
    server_type = "GITHUB"
    token       = data.aws_ssm_parameter.ssm_github_token.value
}

#Create the CodeBuild (since we are using terraform, we actually use code build for code deployment)
resource "aws_codebuild_project" "codebuild" {
    name           = local.cb_name
    description    = var.cb_description
    #build_timeout  = "5"
    #queued_timeout = "5"

    service_role = var.cp_role_arn

    #Source is GitHub
    source {
        type      = "GITHUB"
        location  = var.github_path
        buildspec = var.cb_buildspec_cmd["cmd"] == "NA" ? "${var.cb_buildspec_path}buildspec-${var.github_branch}.yml" : templatefile("${path.module}/templates/${var.cb_buildspec_cmd["cmd"]}.yml.tpl", var.cb_buildspec_cmd["var"])

        auth {
            type     = "OAUTH"
            resource = aws_codebuild_source_credential.github_auth.id
        }
    }

    source_version = "master"

    #No artefacts produced
    artifacts {
        type = "NO_ARTIFACTS"
    }

    #Keep environment as generic as possible
    environment {
        compute_type    = "BUILD_GENERAL1_SMALL"
        image           = "aws/codebuild/standard:2.0"
        type            = "LINUX_CONTAINER"
        privileged_mode = true
    }

    tags = local.cb_tags
}

#Create the CodePipeline
resource "aws_codepipeline" "codepipeline" {
    name     = local.cp_name
    role_arn = var.cp_role_arn

    #Create artefact store as this is mandatory
    artifact_store {
        location = var.artefact_bucket_name
        type     = "S3"
    }

    #First stage to listen to and pull from GitHub
    stage {
        name = "get_${var.github_name}"

        action {
            name             = "get_${var.github_name}_from_gitlab_on_${var.github_branch}"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = [var.cp_name]

            configuration = {
                Owner      = var.github_owner
                Repo       = var.github_name
                Branch     = "master"
                OAuthToken = data.aws_ssm_parameter.ssm_github_token.value
            }
        }
    }

    #Second stage to trigger codebuild which will actually perform the deployment
    stage {
        name = "deploy_${var.github_name}"

        action {
            name            = "deploy_${var.github_name}_according_to_buildspec.yml"
            category        = "Build"
            owner           = "AWS"
            provider        = "CodeBuild"
            version         = "1"
            input_artifacts = [var.cp_name]

            configuration = {
                ProjectName = aws_codebuild_project.codebuild.id
            }
        }
    }

    tags = local.cp_tags

    #Hack to get around the constant refreshing of OAuthToken
    #NOTE: THis means if you change the token, you need to delete the action manually to force terreform to recreate
    lifecycle {
        ignore_changes = [stage[0].action[0].configuration]
    }
}
