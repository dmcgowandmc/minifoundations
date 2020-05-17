# Mini Foundations - AWS

A simple low cost foundations for hobby projects

For a rant on how great this is and what it can do for you, see parent README.md!

## Installation

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

### Deploy Environment

Before running deployment for first time:

* Ensure prepare_terraform_environment was run and IAM user was successfully created
* Create IAM credentials for the IAM user
 * Log into AWS console with user that has permission to modify IAM credentials
 * Go to the security section of the newly created user in the console (E.G: https://console.aws.amazon.com/iam/home#/users/tst-foundations-deploy?section=security_credentials)
 * Create access key and secret and keep in a safe place

Before running in a new terminal session

* Set the credentials as follows:

```bash
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
```

To Initialize foundations and run a plan (this step will download required modules and set statefile location)

```bash
make terraform_init_plan PROJECT_CODE=<3 letter project code> REGION=<desired region>
```

Example:

```bash
[make terraform_init_plan PROJECT_CODE=tst REGION=ap-southeast-2]
```

To actually apply changes (terraform_init_plan must be run first)

```bash
make terraform_apply PROJECT_CODE=<3 letter project code> REGION=<desired region>
```

Example:

```bash
make terraform_apply PROJECT_CODE=tst REGION=ap-southeast-2
```