# Mini Foundations - AWS

A simple low cost foundations on AWS for hobby projects

## Features

Some features of the Mini Foundations AWS:

* Cloud Trail S3 storage for auditing
* Groups for IAM Users
  * Admin group for full access
  * Infra group for power user DevOps engineers
* Roles for CICD Deployment tools
  * Infra role for foundation and application infrastructure deployment
  * App role for deployment of application artefact to S3, ECR, etc
* Best practice network architecture
  * Public, private and data subnets
  * NAT for private and data subnets
  * Support for one or more availability zones
* CICD using CodePipeline and CodeBuild to deploy foundations and infrastructure stack
  * Foundations and application infrastructure follow the GitOps deployment model

## Initial Installation

The following steps detail what is required to initially install the foundations. Once the foundations is installed, you can enhance and modify either using these steps or the steps in ongoing maintenance and upgrades where CodePipeline / CodeDeploy is used control deployment of changes

### Prepare Environment

NOTE: Strongly recommended these steps be performed on an linux based OS or a Mac

* Ensure repo is cloned and you are in the modules/\<cloud_provider\> folder
* Ensure you have an IAM user with at minimum the following policies:
  * IAMFullAccess
  * AmazonS3FullAccess
* Ensure there is a valid key/secret for the IAM user and it is set as follows:

```bash
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
```

* Run the following command

```bash
make prepare_terraform_environment PROJECT_CODE=<3 letter project code> REGION=<desired region>
```

Example:

```bash
make prepare_terraform_environment PROJECT_CODE=tst REGION=ap-southeast-2
```

### Create the SSM parameter store with GitHub token

NOTE: Instructions to actually create the GitHub token to be added

Once you have the GitHub token, follow these steps to create an SSM parameter (sorry no automation yet)

* Log into SSM Parameter Store

```bash
https://ap-southeast-2.console.aws.amazon.com/systems-manager/parameters?region=ap-southeast-2
```

* Click Create Parameter
* Enter as follows
  * Name : github_token
  * Tier : Standard
  * Type : SecureString
  * KMS Key Source : my current account
  * Value : your token

### Create and Set IAM Credentials

You need to create credentials for the bootstrap user that was created in previous step. This is different to the initial user we used as it has higher privileges

Log into AWS console with user that has permission to modify IAM credentials

```bash
https://console.aws.amazon.com/iam/home#/users/<project_code>-u-bootstrap?section=security_credentials)
```

Create access key and secret and keep in a safe place

### Prepare Configuration

If you are cloning this into your own repo, you will need to define a terraform.tfvars file to define the bulk of your settings. Use the template below for your file. Special mention has been made to parameters you really should customize. The rest can be left as default unless there is a specific need to change

```bash
#Inputs for CloudTrail long term storage
ct_bucket_name = "platformtrail"

#Inputs for admin group
group_admin_name        = "administrators"
group_admin_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
]
group_admin_self_management_policy = true


#Inputs for infra group
group_infra_name        = "devops"
group_infra_policy_arns = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/PowerUserAccess"
]
group_infra_self_management_policy = true


#Inputs for infra role
role_infra_name        = "devops"
role_infra_policy_arns = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/PowerUserAccess"
]
role_infra_trusted_services = [
    "codebuild.amazonaws.com",
    "codepipeline.amazonaws.com"
]

#Inputs for fullstack role
role_app_name = "fullstack"
#role_app_policy_arns = [] #Permissions to be defined
role_app_trusted_services = [
    "codebuild.amazonaws.com"
]

#Inputs for foundations VPC
#NOTE: See spreadsheet (to be attached) for allocation of additional CIDRs where additional AZ's are desired. Default uses one AZ to keep costs down but strongly recommend using a minimum of two if possible
vpc_foundations_azs              = ["ap-southeast-2a"]
vpc_foundations_cidr             = "10.0.0.0/19"
vpc_foundations_database_subnets = ["10.0.8.0/23"]
vpc_foundations_private_subnets  = ["10.0.16.0/22"]
vpc_foundations_public_subnets   = ["10.0.0.0/23"]
vpc_foundations_name             = "foundations"

#Inputs for Route 53
prod_zone_fqdn = "test.click"
uat_zone_fqdn  = "uat.test.click"

#Inputs for common CICD components
cp_bucket_name   = "artefacts"
github_owner     = "dmcgowandmc"
ssm_github_token = "github_token"

#Inputs for all foundations CICD components
cb_foundations_description = "Foundations CodeBuild"
cb_foundations_name        = "foundations"
cp_foundations_description = "Foundations Pipeline"
cp_foundations_name        = "foundations"
github_foundations_name    = "minifoundations"
github_foundations_path    = "https://github.com/dmcgowandmc/minifoundations.git"

#Inputs for all webstack CICD components
cb_webstack_description = "Webstack CodeBuild"
cb_webstack_name        = "webstack"
cp_webstack_description = "Webstack Pipeline"
cp_webstack_name        = "webstack"
github_webstack_name    = "webstack"
github_webstack_path    = "https://github.com/dmcgowandmc/webstack.git"
```

### Deploy Environment

Before running in a new terminal session

* Set the credentials from previous step as follows:

```bash
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
```

To Initialize foundations and run a plan (this step will download required modules and set statefile location)

```bash
make terraform_init_plan STATEBUCKET=<full statefile bucket name> PROJECT_CODE=<3 letter project code> REGION=<desired region>
```

Example:

```bash
make terraform_init_plan STATEBUCKET=terrastate-1125 PROJECT_CODE=tst REGION=ap-southeast-2
```

To actually apply changes (terraform_init_plan must be run first)

```bash
make terraform_init_apply PROJECT_CODE=<3 letter project code> REGION=<desired region>
```

Example:

```bash
make terraform_init_apply PROJECT_CODE=tst REGION=ap-southeast-2
```

## Ongoing Maintenance and Updates

For ongoing maintenance and updates, you can modify codebase locally and use the deployment method above to apply changes, however it is strongly recommended to regularly commit changes to GitHub and use the following branch strategy so AWS's CICD tools can also apply changes and ensure code base aligns with GitHub

### feature/<your-feature>

When committing changes, strongly recommend creating a feature branch as follows:

feature/\<your-feature\>

And regularly pushing these changes to GitHub

Code in a feature branch will NOT trigger AWS's CICD tools

### master

The AWS CICD tools are configured to produce a plan anytime a feature is merged into the master branch. To see this, use the following link:

```bash
https://ap-southeast-2.console.aws.amazon.com/codesuite/codepipeline/pipelines/<project-code>-cp-foundations-master/view?region=ap-southeast-2
```

NOTE: If you applied changes during development using the instructions in the initial deployment, then this job may report back that nothing will change. This is normal

### production

The AWS CICD tools are configured to produce a plan AND apply changes anytime master is merged to production branch. To see this, use the following link:

```bash
https://ap-southeast-2.console.aws.amazon.com/codesuite/codepipeline/pipelines/<project-code>-cp-foundations-production/view?region=ap-southeast-2
```

NOTE: If you applied changes during development using the instructions in the initial deployment, then this job may report back that nothing will change. This is normal
