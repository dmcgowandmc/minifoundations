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

Instructions to be provided once I have written some terraform code!