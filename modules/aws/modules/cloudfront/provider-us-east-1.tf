################################################
## Special non-default provider for us-east-1 ##
################################################

#To make life difficult, cloudfront requires it's certificates to reside in us-east-1. So special provider to cater for this. Used by ACM only
provider "aws" {
    alias   = "us_east_1"
    region  = "us-east-1"
    version = "~> 3"
}
