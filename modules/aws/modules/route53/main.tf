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

#Where child zone maps are provided, add the child zone name and its corresponding NS records
#This will allow this zone to also resolve against the zone where the NS records were provided
resource "aws_route53_record" "dev-ns" {
    for_each = var.child_zone_map

    zone_id = var.vpc_id == "" ? aws_route53_zone.public[0].zone_id : aws_route53_zone.private[0].zone_id
    name    = each.key
    type    = "NS"
    ttl     = "30"

    records = each.value
}
