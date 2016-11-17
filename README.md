# bosh-aws-terraform

# terraform + AWS + BOSH Jumpstart

# TODO

* copy private key to jumpbox
* the minimum size of hcp cluster is 3 nodes

## Purpose

This Terraform script has the purpose of jumpstarting the Boostrapping process
for BOSH.

## Requirements

* This Terraform script was tested with Terraform v0.7.10.
* The instructions assume you have a valid PEM key.
* The key and secret for that IAM user must be in the environment variables. See http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html for more details.

## Usage

### Configure

* Open the `variables.tf` file and add regiones/AZ/AMIs as you need.
* You can configure the *prefix* in this file so you won't have to pass it every time in the command line.
* `cp terraform.tfvars.example terraform.tfvars` and edit accordingly.

### Check what resources are going to be created

`terraform plan -var 'prefix=my-cool-prefix'`

### Create

`terraform apply -var 'prefix=my-cool-prefix'`

#### AWS Resources to be created

Upon execution, the script creates:

* 1 VPC
* 1 Elastic IP
* 2 Subnets
* 2 Route tables
* 1 Internet Gateway
* 1 NAT Gateway
* 1 Security group
* 1 Jumpbox

#### Running the bootstrapper

The script, as soon as it finish creating the jumpbox, will create the necessary environment and configure the properties file. Also, it will start the bootstrapping process.

