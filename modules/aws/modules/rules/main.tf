#########################################################################
## All code specifically for the creation of config rules resides here ##
#########################################################################

locals {
    #Resource codes
    cr_resource_code   = "cr"
    crr_resource_code  = "crr"
    crdc_resource_code = "crdc"
    crs_resource_code = "crs"

    #Config rule recorder name
    crr_name = "${var.project_code}-${local.crr_resource_code}-setting"

    #Config rule delivery channel
    crdc_name = "${var.project_code}-${local.crdc_resource_code}-setting"

    #Config rule Name / Tag settings
    cr_names = [for rule in var.cr_rules: "${var.project_code}-${local.cr_resource_code}-${lower(rule)}"]

    # list_tags = [for rule in var.rules:
    #     {
    #         "Name": ${var.project_code}-${local.cr_resource_code}-${lower(rule)}
    #         "Project Code"     = var.project_code,
    #         "Resource Code"    = local.cr_resource_code,
    #         "Customer Code"    = "NA",
    #         "Environment Code" = "NA"
    #     }
    # ]
}

#Get details of account calling these operations
data "aws_caller_identity" "this" {}

#Collect information about the Config Rule Role as different settings are needed for different components
data "aws_iam_role" "crr-role" {
    name = var.crr_role_name
}

#Create custom inline policy to provide access to audit bucket and services monitored by config rules
data "template_file" "cr-access-json" {
    template = file("${path.module}/policies/config-rule-access-policy.json.tbl")

    vars = {
        audit_bucket_id = var.audit_bucket_id
        account_id      = data.aws_caller_identity.this.account_id
    }
}

#Attach the inline policy to the provided role
resource "aws_iam_role_policy" "cp-s3-access-policy" {

    name = "${var.crr_role_name}-cr-access"
    role = data.aws_iam_role.crr-role.id

    policy = data.template_file.cr-access-json.rendered
}

#Create config rule recorder
resource "aws_config_configuration_recorder" "crr" {
    name     = local.crr_name
    role_arn = data.aws_iam_role.crr-role.arn
}

#Create config recorder delivery channel
resource "aws_config_delivery_channel" "crdc" {
    name           = local.crdc_name
    s3_bucket_name = var.audit_bucket_id

    depends_on = [
        aws_config_configuration_recorder.crr,
        aws_iam_role_policy.cp-s3-access-policy
    ]
}

#Enable the config rules
resource "aws_config_configuration_recorder_status" "crs" {
    name       = aws_config_configuration_recorder.crr.name
    is_enabled = true

    depends_on = [
        aws_config_delivery_channel.crdc
    ]
}

#Create config rule (Only AWS provided rules supported at this point)
resource "aws_config_config_rule" "cr" {
    count = length(local.cr_names)
    
    name = local.cr_names[count.index]

    source {
        owner             = "AWS"
        source_identifier = var.cr_rules[count.index]
    }

    depends_on = [
        aws_config_configuration_recorder.crr
    ]
}
