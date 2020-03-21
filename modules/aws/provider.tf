#########################################
## Set Provider and Statefile Location ##
#########################################

#Set Provider
provider "aws" {}

#Set Remote State. All other parameters provided during init
terraform {
    backend "s3" {}
}
