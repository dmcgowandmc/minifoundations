###########################################################################################################
## All code specifically for the creation of vpc's, subnets, and other supporting components reside here ##
###########################################################################################################

locals {
    #Resource code NOTE: Resource and project code will only be used for tags
    vpc_resource_code = "vpc"

    #Name and Tag Settings
    vpc_name = "${var.project_code}-${local.vpc_resource_code}-${var.name}"
    tags = {
        "Name"             = local.vpc_name,
        "Project Code"     = var.project_code,
        "Resource Code"    = local.vpc_resource_code,
        "Customer Code"    = "NA"
        "Environment Code" = "NA"
    }
}

#Create VPC with desired subnets
#NOTE: Since the deal VPC layout can be a bit complex, I am been a bit more prescriptive on how to implement. If causes issues, happy to simplfy and give the user more flexibility
module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 2.0"

    #Name of VPC
    name = local.vpc_name

    #AZ and Subnet Configuration
    azs              = var.azs
    cidr             = var.cidr
    database_subnets = var.database_subnets
    private_subnets  = var.private_subnets
    public_subnets   = var.public_subnets

    #Disable, we will create the database subnet group explictly so all data resources can reside in database subnets
    create_database_subnet_group = false

    #NAT Configuration. This will give you one NAT per AZ for all private subnets
    enable_nat_gateway     = true
    single_nat_gateway     = false
    one_nat_gateway_per_az = true

    #Standard endpoints to enable. This allows resources within VPC to talk directly to AWS API's without heading out to the internet
    enable_dynamodb_endpoint = true
    enable_s3_endpoint       = true

    tags = local.tags
}
