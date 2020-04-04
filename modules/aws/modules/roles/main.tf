##################################################################
## All code specifically for the creation of roles resides here ##
##################################################################

module "iam_assumable_role" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version = "~> 2.0"

    role_name               = "${var.project_code}-${var.name}"
    create_role             = true
    custom_role_policy_arns = var.policy_arns
    trusted_role_services   = var.trusted_services

    # trusted_role_services = [
    #     "codebuild.amazonaws.com"
    # ]

    # custom_role_policy_arns = [
    #     "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
    #     "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
    # ]
}