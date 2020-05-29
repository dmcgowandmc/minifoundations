##################################################################
## All code specifically for the creation of roles resides here ##
##################################################################

locals {
    #Resource code
    role_resource_code = "r"
}

#Create role
module "iam_assumable_role" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version = "~> 2.0"

    create_role             = true
    custom_role_policy_arns = var.policy_arns
    role_name               = "${var.project_code}-${local.role_resource_code}-${var.name}"
    role_requires_mfa       = false
    trusted_role_services   = var.trusted_services
}

#Create and attach a custom policy that allows use of the secure token service (sts)

#Why? Within docker, we have to actually pass in credentials, fixed or otherwise. So beforehand, we need to explicitly call sts, obtain the 
#temporary credentials, and pass to docker as input variables

#Create the custom policy
resource "aws_iam_policy" "assume-policy" {
    name        = "${var.project_code}-${local.role_resource_code}-${var.name}-assume-sts"
    path        = "/"
    description = "Enable use of the secure token service for ${var.project_code}-${local.role_resource_code}-${var.name}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "stsAssumeRole",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "sts:GetCallerIdentity"
            ],
            "Resource": "${module.iam_assumable_role.this_iam_role_arn}"
        }
    ]
}
EOF
}

#Attach the custom policy to the previosly created role
resource "aws_iam_role_policy_attachment" "assume-policy-to-assumeable-role" {
    role       = module.iam_assumable_role.this_iam_role_name
    policy_arn = aws_iam_policy.assume-policy.arn
}