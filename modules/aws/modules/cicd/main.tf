##############################################################################################
## All code for creating a CICD pipeline using code commit, build and pipeline defined here ##
##############################################################################################

#Create the CodePipeline
resource "aws_codepipeline" "codepipeline" {
    name     = "${var.project_code}-${var.cp_name}"
    role_arn = var.cp_role_arn

    artifact_store {
        location = var.artefact_bucket_name
        type     = "S3"
    }

    stage {
        name = "get_${var.cp_repo}"

        action {
            name             = "get_${var.cp_repo}_from_gitlab"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = [var.cp_name]

            configuration = {
                Owner      = "dmcgowandmc"
                Repo       = "minifoundations"
                Branch     = "master"
                OAuthToken = var.cp_repo_oauthtoken
            }
        }
    }

    stage {
        name = "execute_${var.cp_repo}"

        action {
            name            = "deploy_${var.cp_repo}_according_to_buildspec.yml"
            category        = "Build"
            owner           = "AWS"
            provider        = "CodeBuild"
            version         = "1"
            input_artifacts = [var.cp_name]

            configuration = {

            }
        }
    }
}

#Create a code build configuration (since we are using terraform, we actually use code build for code deploy)
