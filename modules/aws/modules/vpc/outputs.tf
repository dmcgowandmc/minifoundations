##################################################################################################
## All outputs from the creation of vpc's, subnets, and other supporting components reside here ##
##################################################################################################

output "database_subnet_arns" {
    description = "List of ARN's for the Database Subnets"
    value       = module.vpc.database_subnet_arns
}

output "database_subnets" {
    description = "List of ID's for the Database Subnets"
    value       = module.vpc.database_subnets
}

output "private_subnet_arns" {
    description = "List of ARN's for the Private Subnets"
    value       = module.vpc.private_subnet_arns
}

output "private_subnets" {
    description = "List of ID's for the Private Subnets"
    value       = module.vpc.private_subnets
}

output "public_subnet_arns" {
    description = "List of ARN's for the Public Subnets"
    value       = module.vpc.public_subnet_arns
}

output "public_subnets" {
    description = "List of ID's for the Public Subnets"
    value       = module.vpc.public_subnets
}

output "vpc_id" {
    description = "ID of the VPC"
    value       = module.vpc.vpc_id
}
