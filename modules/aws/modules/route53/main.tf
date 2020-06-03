###########################################################################
## All code specifically for the creation of route 53 zones resides here ##
###########################################################################

locals {
    #Resource code NOTE: Resource and project code will only be used for tags
    role_resource_code = "r53"
}

#Create a public zone (where no VPC ID provided)
resource "aws_route53_zone" "public" {
    count = var.vpc_id == "" ? 1 : 0

    force_destroy = var.force_destory
    name          = var.zone_fqdn
}

#Create a private zone (where VPC ID provided)
resource "aws_route53_zone" "private" {
    count = var.vpc_id == "" ? 0 : 1

    force_destroy = var.force_destory
    name          = var.zone_fqdn
}
