######################################################################
## All code for creating a cloudfront distribution are defined here ##
######################################################################

locals {
    #Resource codes
    cf_resource_code  = "cf"
    cfo_resource_code = "cfo"

    #Name and Tag Settings
    cfo_name = "${var.project_code}-${local.cfo_resource_code}-${var.customer_code}-${var.environment_code}-${var.cf_s3_origin_id}"
    cf_name = "${var.project_code}-${local.cf_resource_code}-${var.customer_code}-${var.environment_code}-${var.cf_distribution_description}"
    tags = merge(
        {
            "Name"             = local.cf_name,
            "Project Code"     = var.project_code,
            "Resource Code"    = local.cf_resource_code,
            "Customer Code"    = var.customer_code
            "Environment Code" = var.environment_code
        },
        var.tags
    )

    #construct FQDNs aliases based on provided cf_fqdn_aliases and the r53_fqdn. This may still be a 
    r53_fqdn_aliases = [for alias in var.r53_aliases : "${alias}.${var.r53_fqdn}"]

    #create a list of aliases AND the fqdn. In a few parts of this module, we will need the complete list
    r53_fqdn_all = concat(local.r53_fqdn_aliases, [var.r53_fqdn])
}

#Get details of account calling these operations
data "aws_caller_identity" "this" {}

#Create a certificate with r53_fqdn as the CN and r53_fqdn_aliases as SANs
#NOTE: This certificate must reside in us-east-1. This is a requirement of cloudfront
resource "aws_acm_certificate" "cf-cert" {
    provider = aws.us_east_1

    domain_name               = var.r53_fqdn
    subject_alternative_names = local.r53_fqdn_aliases
    validation_method         = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

#Add certificate CNAME records to Route53 for validation
resource "aws_route53_record" "cf-cert-validation" {
    for_each = {
        for dvo in aws_acm_certificate.cf-cert.domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            type   = dvo.resource_record_type
            record = dvo.resource_record_value
        }
    }

    zone_id = var.r53_zone_id
    name    = each.value.name
    type    = each.value.type
    records = [each.value.record]
    ttl     = 60
}

#Ensure validation actually takes place and certs are ready to go before proceeding any further
#DOESN'T WORK. I SUSPECT THIS IS DUE THE ROUTE53 ZONE AND THE ACM BEEN DIFFERENT REGIONS
# resource "aws_acm_certificate_validation" "cf-cert-validation-conf" {
#     provider = aws.us_east_1

#     certificate_arn         = aws_acm_certificate.cf-cert.arn
#     validation_record_fqdns = local.r53_fqdn_all
# }

#Dirty hack to get around validation issue. Pause for 5 minutes if cf-cert-validation is required
resource "time_sleep" "wait_5_minutes" {

    create_duration = "5m"

    triggers = {
        # Only delay if changes to cf-cert-validation
        r53_fqdn_all_hash = base64encode(join("|",local.r53_fqdn_all))
    }
}

#Create a cloudfront origin access identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = local.cfo_name
}

#Create a cloudfront distribution
resource "aws_cloudfront_distribution" "distribution" {

    #Distribution wide settings
    enabled             = true
    comment             = local.cf_name
    default_root_object = var.cf_default_root_object
    http_version        = "http2"

    #Define additional aliases. At minimum, this will be the r53_fqdn but may consist of multiple aliases
    aliases = local.r53_fqdn_all

    #Define GEO restrictions. For now, not customizable
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    #Define certificates and SSL settings. Certificates must reside in the us-east-1 region :(
    #Enforcing TLS1.2. No reason anyone should be using anything less
    viewer_certificate {
        acm_certificate_arn      = aws_acm_certificate.cf-cert.arn
        minimum_protocol_version = "TLSv1.2_2018"
        ssl_support_method       = "sni-only"
    }

    #Define logging configuration
    logging_config {
        include_cookies = false
        bucket          = var.cf_s3_audit_bucket_regional_domain_name
        prefix          = "AWSLogs/${data.aws_caller_identity.this.account_id}/CloudFront/${var.project_code}-${var.customer_code}-${var.environment_code}-${local.cf_resource_code}-${var.cf_distribution_description}/"
    }
    
    ## Origin Configurations ##

    #Define origin to s3 bucket for static content
    origin {
        domain_name = var.cf_s3_origin_bucket_regional_domain_name
        origin_id   = "${var.project_code}-${var.customer_code}-${var.environment_code}-${local.cf_resource_code}-${var.cf_s3_origin_id}"

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
        }
    }

    ##PLACEHOLER FOR ADDITIONAL ORIGINS

    #Default cache behavior for origin of s3 bucket for static content. Accept everything but only cache GET and HEAD
    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "${var.project_code}-${var.customer_code}-${var.environment_code}-${local.cf_resource_code}-${var.cf_s3_origin_id}"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    tags = local.tags

    depends_on = [
        time_sleep.wait_5_minutes
    ]
}

#Configure bucket policy to allow cloudfront distribution to access the s3 bucket
#Create the policy
data "template_file" "ws_s3_bucket_policy_json" {
    template = file("${path.module}/policies/ws-s3-bucket-policy.json.tpl")

    vars = {
        cf_oai_iam_arn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        s3_bucket_arn  = var.cf_s3_origin_bucket_arn
    }
}

#Apply the policy
resource "aws_s3_bucket_policy" "ws_s3_bucket_policy" {
    bucket = var.cf_s3_origin_bucket_id

    policy = data.template_file.ws_s3_bucket_policy_json.rendered
}

#Ensure all FQDNs are added as aliases records for the cloudfront distribution. This must be done after the cloudfront distribution is created
resource "aws_route53_record" "cf-aliases" {
    count = length(local.r53_fqdn_all)

    zone_id = var.r53_zone_id
    name    = local.r53_fqdn_all[count.index]
    type    = "A"

    alias {
        name                   = aws_cloudfront_distribution.distribution.domain_name
        zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
        evaluate_target_health = false
    }
}
