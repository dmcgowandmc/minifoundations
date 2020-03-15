# Mini Foundations

A simple low costs foundations for hobby projects

## About Mini Foundations

A lot of foundations are oriented towards medium to large business. While they are well suited for these businesses, they are complex and expensive for people looking to do some basic hobby projects but at the same time, want to maintain some standards and comply to best practices

This aims to fill the gap.

For AWS at the moment but eventually want to support the big three (AWS, GCP, Azure)

## Features

Foundations written as IAC in Terraform and deployable via commandline or CICD tool. Outputs can be leveraged for you to build your own infrastructure on top using terraform

Some features of the foundations:

* Best practice network architecture
* Best practice security

## How to use

### Prepare

Regardless of the cloud provider, there are a few steps you need to perform before you can use terraform such as creating valid credentials and a location to store the terraform state file.

In each module/\<cloud_provider\> folder, there is a make file that can do these prepare tasks for you and a README.md with instructions. Please note that these make files use bash scripts and there behavior can be inconsistent depending on what you run these steps on. Strongly recommended to run on a Ubuntu or Debian distro

### Deployment

For actual deployment using terraform (once prepare steps are completed), you have two options:

#### Option 1

The simple option is customize your terraform inputs and run the Make file as directed in the README.md in module/\<cloud_provider\>. Under this option, the intent is for you to effectively create your own repo and modify this code as you wish. From this point it would permanently diverge from the maintained repo

You will need to run the Make file on a system with Docker and Compose installed

#### Option 2

The more complex but robust and referred option, is to create your own terraform repo and leverage the code in module/\<cloud_provider\> as modules in your own code. This option take a bit more effort and more understanding of terraform, but is more robust and ensures your are always getting the latest code.
