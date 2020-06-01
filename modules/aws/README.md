# Mini Foundations - AWS

A simple low cost foundations for hobby projects

For a rant on how great this is and what it can do for you, see parent README.md!

## Features

More detail to be added

## Initial Installation

The following steps detail what is required to initially install the foundations. Once the foundations is installed, you can enhance and modify either using these steps or the steps in ongoing maintenance and upgrades where CodePipeline / CodeDeploy is used control deployment of changes

### Prepare Environment

NOTE: Strongly recommended these steps be performed on an Ubuntu or Debian based distro

* Ensure repo is cloned and you are in the modules/\<cloud_provider\> folder
* Run the following command

```bash
make prepare_terraform_environment PROJECT_CODE=<3 letter project code> REGION=<desired region>
```

Example:

```bash
make prepare_terraform_environment PROJECT_CODE=tst REGION=ap-southeast-2
```

### Create the SSM parameter store with GitHub token

Instructions to actually create the GitHub token to be added

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

You need to create credentials for the bootstrap user that was created in previous step

Log into AWS console with user that has permission to modify IAM credentials

```bash
https://console.aws.amazon.com/iam/home#/users/<project_code>-u-bootstrap?section=security_credentials)
```

Create access key and secret and keep in a safe place

### Prepare Configuration

This is the part of any deployment that sucks. Going through all the configuration options and customizing it to suite your needs.

The guide below goes over all the configuration items. There are a number of items that can be left as default and a number of others that really should be tailored for your needs.

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

