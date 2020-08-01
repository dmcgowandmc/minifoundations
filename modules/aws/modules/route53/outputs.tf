##################################################################
## All outputs from the creation of route 53 zones resides here ##
##################################################################

output "name_servers" {
    description = "A list of the zone name servers"
    value       = var.vpc_id == "" ? aws_route53_zone.public[0].name_servers : aws_route53_zone.private[0].name_servers
}

output "private_zone" {
    description = "This zone is private?"
    value       = var.vpc_id == "" ? false : true
}

output "zone_fqdn" {
    description = "The zone FQDN"
    value       = var.zone_fqdn
}

output "zone_id" {
    description = "The zone ID"
    value       = var.vpc_id == "" ? aws_route53_zone.public[0].zone_id : aws_route53_zone.private[0].zone_id
}
