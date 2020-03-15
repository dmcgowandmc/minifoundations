#!/bin/bash

# Simple shell script sets the minimum environment for AWS Mini Foundations. Once done, the terraform modules do the rest

# Creates
# * terrastate bucket with bublic access blocked, encryptin and versioning enabled
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

if [[ -z $(aws s3api list-buckets --query "Buckets[].Name" --output=text | grep $PROJECT_CODE-terrastate) ]]; then

    aws s3api create-bucket \
    --bucket $PROJECT_CODE-terrastate \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION

    aws s3api put-public-access-block \
    --bucket $PROJECT_CODE-terrastate \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

    aws s3api put-bucket-encryption \
    --bucket $PROJECT_CODE-terrastate \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

    aws s3api put-bucket-versioning \
    --bucket $PROJECT_CODE-terrastate \
    --versioning-configuration Status=Enabled

    printf "\xE2\x9C\x94 \n"
else
    printf ". Bucket found\xE2\x9C\x94 \n"
fi

#Create deployment role
printf "Verify foundations deployment role exists"

if [[ -z $(aws iam list-roles --query Roles[].RoleName --output=text | grep $PROJECT_CODE-foundations-deploy) ]]; then
    
    aws iam create-role \
    --role-name $PROJECT_CODE-foundations-deploy \
    --assume-role-policy-document "file://$(pwd)/modules/aws/scripts/configs/trust.json"
    
    printf "\xE2\x9C\x94 \n"
else
    printf ". Role found\xE2\x9C\x94 \n"
fi

#Assign relevant policies to deployment role
printf "Assign relevant policies to deployment role"

DEPLOYMENT_POLICIES="$(pwd)/modules/aws/scripts/configs/policies.txt"
while IFS= read -r LINE
do
    printf ". \n Add $LINE"

    aws iam attach-role-policy \
    --role-name $PROJECT_CODE-foundations-deploy \
    --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

    printf "\xE2\x9C\x94 \n"
done < "$DEPLOYMENT_POLICIES"

#Create IAM user for external deployment access
printf "Verify foundations deployment IAM user exists"

if [[ -z $(aws iam list-users --query Users[].UserName --output=text | grep $PROJECT_CODE-foundations-deploy) ]]; then

    aws iam create-user \
    --user-name $PROJECT_CODE-foundations-deploy

    # aws iam attach-user-policy \
    # --user-name $PROJECT_CODE-foundations-deploy \
    # --policy-arn '{"Version":"2012-10-17","Statement":{"Effect":"Allow","Action":"sts:AssumeRole","Resource":"arn:aws:iam::ACCOUNT-ID-WITHOUT-HYPHENS:role/Test*"}}'

    printf "\xE2\x9C\x94 \n WARNING: Script doesn't create policy to allow IAM user to assume IAM role yet. You must do this manually if needed"
else
    printf ". IAM user found\xE2\x9C\x94 \n"
fi

