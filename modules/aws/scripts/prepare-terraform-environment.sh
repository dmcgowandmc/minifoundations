#!/bin/bash

# Simple shell script sets the minimum environment for AWS Mini Foundations. Once done, the terraform modules do the rest

# Creates
# * terrastate bucket with bublic access blocked, encryption and versioning enabled
# * IAM role with sufficient priviliedges to perform deployment tasks
# * IAM user to assume IAM role in event deployment is been performed by resource outside of AWS

# NOTE: Strongly recommend running this on latest Ubuntu or Debian OS. AWS CLI 2.x or higher required

# Following Enhancements Needed
# * Need to create policy to IAM user can assume IAM role.
# * Want to hide output of CLI on success
# * Add tags to resources

# Prepare Variables
PROJECT_CODE=$1
REGION=$2
ACCOUNT=$(aws sts get-caller-identity --query Account --output=text)
POSTFIX=$(hexdump -n 2 -e '4/4 "%04X" 1 "\n"' /dev/random | tr '[:upper:]' '[:lower:]')

# Verify project code
printf "Verifying project code. Should be three letters max, lower case, no numbers"

if [[ -z $PROJECT_CODE ]]; then
    printf ". No project code provided \n"
    exit 1
fi

if ! [[ $PROJECT_CODE =~ ^[a-z]{3}$ ]]; then
    printf ". Should be three letters max, lower case, no numbers \n"
    exit 1
fi

printf "\xE2\x9C\x94 \n"

# Verify region
printf "Verify region provided (we don't check if it's valid at this time)"

if [[ -z $REGION ]]; then
    printf ". No region provided \n"
    exit 1
fi

printf "\xE2\x9C\x94 \n"

# Check for S3 bucket and create if it doesn't exist
# Make sure all public access is blocked, encryption enabled and versioning is on
printf "Ensuring terrastate bucket exists"

#Note, we are looking for the keyword of terrastate and ignoring the postfix as it will change on each run
if [[ -z $(aws s3api list-buckets --query "Buckets[].Name" --output=text | grep terrastate) ]]; then

    aws s3api create-bucket \
    --bucket terrastate-$POSTFIX \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION

    aws s3api put-public-access-block \
    --bucket terrastate-$POSTFIX \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

    aws s3api put-bucket-encryption \
    --bucket terrastate-$POSTFIX \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

    aws s3api put-bucket-versioning \
    --bucket terrastate-$POSTFIX \
    --versioning-configuration Status=Enabled

    printf "\xE2\x9C\x94 \n"
else
    printf ". Bucket found\xE2\x9C\x94 \n"
fi

#Create IAM user for external deployment access
printf "Verify foundations deployment IAM user exists"

if [[ -z $(aws iam list-users --query Users[].UserName --output=text | grep $PROJECT_CODE-u-bootstrap) ]]; then

    #Create a bootstrap IAM user so foundations can be deployed
    aws iam create-user \
    --user-name $PROJECT_CODE-u-bootstrap

    printf "\xE2\x9C\x94 \n WARNING: Script doesn't create policy to allow IAM user to assume IAM role yet. You must do this manually if needed"
else
    printf ". IAM user found\xE2\x9C\x94 \n"
fi

#Assign relevant policies to deployment IAM user
printf "Assign relevant policies to deployment IAM user"

DEPLOYMENT_POLICIES="$(pwd)/scripts/configs/policies.txt"
while IFS= read -r LINE
do
    printf ". \n Add $LINE"

    aws iam attach-user-policy \
    --user-name $PROJECT_CODE-u-bootstrap \
    --policy-arn $LINE

    printf "\xE2\x9C\x94 \n"
done < "$DEPLOYMENT_POLICIES"
