##############################################################################################
## All code for creating a CICD pipeline using code commit, build and pipeline defined here ##
##############################################################################################

#Create the CodeBuild (since we are using terraform, we actually use code build for code deployment)
resource "aws_codebuild_project" "codebuild" {
    name           = "${var.project_code}-${var.cb_name}"
    description    = var.cb_description
    #build_timeout  = "5"
    #queued_timeout = "5"

    service_role = var.cp_role_arn

    source {
        type = "CODEPIPELINE"
    }

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image        = "aws/codebuild/standard:2.0"
        type         = "LINUX_CONTAINER"
    }
}

#Create the CodePipeline
resource "aws_codepipeline" "codepipeline" {
    name     = "${var.project_code}-${var.cp_name}"
    role_arn = var.cp_role_arn

    artifact_store {
        location = var.artefact_bucket_name
        type     = "S3"
    }

    stage {
        name = "get_${var.cp_repo_name}"

        action {
            name             = "get_${var.cp_repo_name}_from_gitlab_on_master"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = [var.cp_name]

            configuration = {
                Owner      = var.cp_repo_owner
                Repo       = var.cp_repo_name
                Branch     = "master"
                OAuthToken = var.cp_repo_oauthtoken
            }
        }

        action {
            name             = "get_${var.cp_repo_name}_from_gitlab_on_production"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = [var.cp_name]

            configuration = {
                Owner      = var.cp_repo_owner
                Repo       = var.cp_repo_name
                Branch     = "production"
                OAuthToken = var.cp_repo_oauthtoken
            }
        }
    }

    stage {
        name = "deploy_${var.cp_repo_name}"

        action {
            name            = "deploy_${var.cp_repo_name}_according_to_buildspec.yml"
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
}
