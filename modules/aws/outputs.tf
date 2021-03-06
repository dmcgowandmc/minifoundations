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

#Outputs for CICD artefact storage
output "cp_s3_bucket_name" {
    description = "The name of the code pipeline bucket (excluding random prefix)"
    value       = module.cp_s3_bucket.s3_bucket_name
}

output "cp_s3_bucket_id" {
    description = "The name of the code pipeline bucket (random prefix + bucket name)"
    value       = module.cp_s3_bucket.s3_bucket_id
}

output "cp_s3_bucket_arn" {
    description = "The ARN of the code pipeline bucket. Will be of format arn:aws:s3:::bucketname."
    value       = module.cp_s3_bucket.s3_bucket_arn
}

output "cp_s3_bucket_regional_domain_name" {
    description = "The regional domain name of this code pipeline bucket"
    value       = module.cp_s3_bucket.s3_bucket_regional_domain_name
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

#Outputs for internal Route53 zone
output "zone_id" {
    description = "The internal zone ID"
    value       = module.private_route53.zone_id
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

output "vpc_foundations_vpc_id" {
    description = "ID of the foundations VPC for foundations"
    value       = module.vpc_foundations.vpc_id
}
