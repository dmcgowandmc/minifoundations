#########################################
## Set Provider and Statefile Location ##
#########################################

#Init Terraform and Set Remote State. All other parameters provided during init via the makefile
terraform {
    backend "s3" {}
}


#Set Provider
provider "aws" {
    region = var.region
}
