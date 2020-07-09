##################################################
## All outputs for base code should reside here ##
##################################################

#Global Outputs
output "project_code" {
    description = "Three letter prefix to identity your resources. All you resources should be prefixed with this code"
    value       = var.project_code
}

output "region" {
    description = "The default region your resources will reside in"
    value       = var.region
}

output "statebucket" {
    description = "The name of the s3 bucket that stores the statefiles"
    value       = var.statebucket
}

#Outputs for long term storage of logs for auditing
output "audit_s3_bucket_name" {
    description = "The name of the audit bucket (excluding random prefix)"
    value       = module.audit_s3_bucket.s3_bucket_name
}

output "audit_s3_bucket_id" {
    description = "The name of the audit bucket (random prefix + bucket name)"
    value       = module.audit_s3_bucket.s3_bucket_id
}

output "audit_s3_bucket_arn" {
    description = "The ARN of the audit bucket. Will be of format arn:aws:s3:::bucketname."
    value       = module.audit_s3_bucket.s3_bucket_arn
}

output "audit_s3_bucket_regional_domain_name" {
    description = "The regional domain name of this audit bucket"
    value       = module.audit_s3_bucket.s3_bucket_regional_domain_name
}

#Outputs for cloudtrail
output "ct_id" {
    description = "The ID of the cloud trail"
    value       = aws_cloudtrail.accesstrail.id
}

output "ct_arn" {
    description = "The ARN of the cloud trail"
    value       = aws_cloudtrail.accesstrail.arn
}

#Outputs for admin group
output "group_admin_name" {
    description = "Name of the the admin group"
    value       = module.admin_group.group_name
}

#Outputs for infra group
output "group_infra_name" {
    description = "Name of the the infra group"
    value       = module.infra_group.group_name
}

#Outputs for infra role
output "role_infra_name" {
    description = "Name of the infra role"
    value       = module.infra_role.role_name
}

output "role_infra_arn" {
    description = "ARN of the infra role"
    value       = module.infra_role.role_arn
}

#Outputs for app role
output "role_app_name" {
    description = "Name of the app role"
    value       = module.app_role.role_name
}

output "role_app_arn" {
    description = "ARN of the app role"
    value       = module.app_role.role_arn
}

#Outputs for Route53. Output values into a list so we can easily refer to the environment we want
output "zone_id" {
    description = "The production zone ID"
    value       = {
        "prod" = module.pub_prod_route53.zone_id
        "uat"  = module.uat_prod_route53.zone_id
    }
}

output "zone_fqdn" {
    description = "The UAT zone FQDN"
    value       = {
        "prod" = var.prod_zone_fqdn
        "uat"  = var.uat_zone_fqdn
    }
}

#Outputs for VPC foundations
output "vpc_foundations_database_subnet_arns" {
    description = "List of ARN's for the foundations Database Subnets"
    value       = module.vpc_foundations.database_subnet_arns
}

output "vpc_foundations_database_subnets" {
    description = "List of ID's for the foundations Database Subnets"
    value       = module.vpc_foundations.database_subnets
}

output "vpc_foundations_private_subnet_arns" {
    description = "List of ARN's for the foundations Private Subnets"
    value       = module.vpc_foundations.private_subnet_arns
}

output "vpc_foundations_private_subnets" {
    description = "List of ID's for the foundations Private Subnets"
    value       = module.vpc_foundations.private_subnets
}

output "vpc_foundations_public_subnet_arns" {
    description = "List of ARN's for the foundations Public Subnets"
    value       = module.vpc_foundations.public_subnet_arns
}

output "vpc_foundations_public_subnets" {
    description = "List of ID's for the foundations Public Subnets"
    value       = module.vpc_foundations.public_subnets
}

output "vpc_foundations_ssm_security_group_arn" {
    description = "ID of the SSM Endpoint security group for foundations"
    value       = module.vpc_foundations.ssm_security_group_arn
}

output "vpc_foundations_ssm_security_group_id" {
    description = "ID of the SSM Endpoint security group for foundations"
    value       = module.vpc_foundations.ssm_security_group_id
}

output "vpc_foundations_vpc_id" {
    description = "ID of the foundations VPC for foundations"
    value       = module.vpc_foundations.vpc_id
}