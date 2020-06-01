###########################################################################################################
## All code specifically for the creation of vpc's, subnets, and other supporting components reside here ##
###########################################################################################################

locals {
    #Resource code NOTE: Resource and project code will only be used for tags
    role_resource_code = "vpc"
}

#Create VPC with desired subnets
#NOTE: Since the deal VPC layout can be a bit complex, I am been a bit more prescriptive on how to implement. If causes issues, happy to simplfy and give the user more flexibility
module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 2.0"

    #Name of VPC
    name = "${var.project_code}-${local.role_resource_code}-${var.name}"

    #AZ and Subnet Configuration
    azs              = var.azs
    cidr             = var.cidr
    database_subnets = ["10.0.8.0/23", "10.0.10.0/23"]
    private_subnets  = ["10.0.16.0/22", "10.0.20.0/22"]
    public_subnets   = ["10.0.0.0/23", "10.0.2.0/23"]

    #Disable, we will create the database subnet group explictly so all data resources can reside in database subnets
    create_database_subnet_group = false

    #NAT Configuration. This will give you one NAT per AZ for all private subnets
    enable_nat_gateway     = true
    single_nat_gateway     = false
    one_nat_gateway_per_az = true

    #Standard endpoints to enable. This allows resources within VPC to talk directly to AWS API's without heading out to the internet
    enable_s3_endpoint                      = true
    enable_ssm_endpoint                     = true
    enable_ssmmessages_endpoint             = true
    ssm_endpoint_security_group_ids         = [aws_security_group.ssm.id]
    ssmmessages_endpoint_security_group_ids = [aws_security_group.ssm.id]
}

#Create generic security group for SSM endpoints. Allow for HTTPS only
resource "aws_security_group" "ssm" {
    name        = "${module.vpc.name}-ssm"
    description = "Allow inbound traffic to SSM endpoint"
    vpc_id      = module.vpc.vpc_id

    ingress {
        description = "Allow HTTPS from entire VPC CIDR Range"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [module.vpc.vpc_cidr_block]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
