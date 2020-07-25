##############################################################################################
## All code for creating a CICD pipeline using code commit, build and pipeline defined here ##
##############################################################################################

#NOTE: Not happy with this design, but attempting to work around CodeBuild / CodePipelines rigid and inflexible model to implement GitOps
#For foundations, GitOps consists of master and production but since there is no concept of environments, master branch produces a plan, and production branch actually results in deployment
#For everything else, master is generally a UAT deployment, and production is a production deployment

locals {
    #Resource codes
    cb_resource_code = "cb"
    cp_resource_code = "cp"
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

#Create the CodeBuild for master (since we are using terraform, we actually use code build for code deployment)
resource "aws_codebuild_project" "codebuild-master" {
    name           = "${var.project_code}-${local.cb_resource_code}-${var.cb_name}-master"
    description    = var.cb_description
    #build_timeout  = "5"
    #queued_timeout = "5"

    service_role = var.cp_role_arn

    #Source is GitHub
    source {
        type      = "GITHUB"
        location  = var.github_path
        buildspec = var.cb_buildspec_cmd == {} ? "${var.cb_buildspec_path}buildspec-master.yml" : templatefile("${path.module}/templates/${var.cb_buildspec_cmd["cmd"]}.yml.tpl", var.cb_buildspec_cmd["varuat"])

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
}

#Create the CodeBuild for production (since we are using terraform, we actually use code build for code deployment)
resource "aws_codebuild_project" "codebuild-production" {
    name           = "${var.project_code}-${local.cb_resource_code}-${var.cb_name}-production"
    description    = var.cb_description
    #build_timeout  = "5"
    #queued_timeout = "5"

    service_role = var.cp_role_arn

    #Source is GitHub
    source {
        type      = "GITHUB"
        location  = var.github_path
        buildspec = var.cb_buildspec_cmd == {} ? "${var.cb_buildspec_path}buildspec-production.yml" : templatefile("${path.module}/templates/${var.cb_buildspec_cmd["cmd"]}.yml.tpl", var.cb_buildspec_cmd["varprd"])

        auth {
            type     = "OAUTH"
            resource = aws_codebuild_source_credential.github_auth.id
        }
    }

    source_version = "production"

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
}

#Create the CodePipeline for master branch
resource "aws_codepipeline" "codepipeline-master" {
    name     = "${var.project_code}-${local.cp_resource_code}-${var.cp_name}-master"
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
            name             = "get_${var.github_name}_from_gitlab_on_master"
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
                ProjectName = aws_codebuild_project.codebuild-master.id
            }
        }
    }

    #Hack to get around the constant refreshing of OAuthToken
    #NOTE: THis means if you change the token, you need to delete the action manually to force terreform to recreate
    lifecycle {
        ignore_changes = [stage[0].action[0].configuration]
    }
}

#Create the CodePipeline for production branch
resource "aws_codepipeline" "codepipeline-production" {
    name     = "${var.project_code}-${local.cp_resource_code}-${var.cp_name}-production"
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
            name             = "get_${var.github_name}_from_gitlab_on_production"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = [var.cp_name]

            configuration = {
                Owner      = var.github_owner
                Repo       = var.github_name
                Branch     = "production"
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
                ProjectName = aws_codebuild_project.codebuild-production.id
            }
        }
    }

    #Hack to get around the constant refreshing of OAuthToken
    #NOTE: This means if you change the token, you need to delete the action manually to force terreform to recreate
    lifecycle {
        ignore_changes = [stage[0].action[0].configuration]
    }
}
