##################################################################
## All code specifically for the creation of roles resides here ##
##################################################################

locals {
    #Resource code
    role_resource_code = "r"

    #Name and Tag Settings
    role_name = var.customer_code == "" && var.environment_code == "" ? "${var.project_code}-${local.role_resource_code}-${var.name}" : var.environment_code == "" ? "${var.project_code}-${local.role_resource_code}-${var.customer_code}-${var.name}" : "${var.project_code}-${local.role_resource_code}-${var.customer_code}-${var.environment_code}-${var.name}"
    tags = merge(
        {
            "Name"             = local.role_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.role_resource_code,
            "Customer Code"    = var.customer_code == "" ? "NA" : var.customer_code,
            "Environment Code" = var.environment_code == "" ? "NA" : var.environment_code
        },
        var.tags
    )
}

#Create role
module "iam_assumable_role" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version = "~> 2.0"

    create_role             = true
    custom_role_policy_arns = var.policy_arns
    role_name               = local.role_name
    role_requires_mfa       = false
    trusted_role_services   = var.trusted_services
    tags                    = local.tags
}

#Create and attach a custom policy that allows use of the secure token service (sts)

#Why? Within docker, we have to actually pass in credentials, fixed or otherwise. So beforehand, we need to explicitly call sts, obtain the 
#temporary credentials, and pass to docker as input variables

#Create the custom policy
resource "aws_iam_policy" "assume-policy" {
    #FIX REQUIRED
    name        = "${local.role_name}-assume-sts"
    path        = "/"
    description = "Enable use of the secure token service for ${local.role_name}"

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