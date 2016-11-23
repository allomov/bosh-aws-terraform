variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_public_key" {}
variable "aws_private_key" {}


variable "prefix" {
  description = "A prefix to easily identify the resources in AWS"
  default = "aws"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "aws_az" {
    description = "EC2 availability zone for the VPC"
    default = "us-east-1c"
}

variable "amis" {
    description = "Ubuntu 16.04 LTS AMIs by region"
    default = {
        us-east-1 = "ami-45b69e52"
        us-west-2 = "ami-9ee24ffe"
        us-west-1 = "ami-dab5e0ba"
        eu-west-1 = "ami-07174474"
        eu-central-1 = "ami-82cf0aed"
        ap-southeast-1 = "ami-5b268538"
        ap-northeast-1 = "ami-483f9429"
        ap-southeast-2 = "ami-e199a682"
        ap-northeast-2 = "ami-27825549"
        ap-south-1 = "ami-dfd1a5b0"
        sa-east-1 = "ami-0c188760"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}

variable "jumpbox_user" {
    description = "jumpbox user name (default: ubuntu)"
    default = "ubuntu"
}
