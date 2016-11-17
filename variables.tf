variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

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
    description = "AMIs by region"
    default = {
        us-east-1      = "ami-2d39803a"
        us-west-2      = "ami-42569022"
        us-west-1      = "ami-992661f9"
        eu-west-1      = "ami-02b62c71"
        eu-central-1   = "ami-4bd03b24"
        ap-southeast-1 = "ami-ea2bf989"
        ap-northeast-1 = "ami-2e63924f"
        ap-southeast-2 = "ami-396a415a"
        ap-northeast-2 = "ami-979258f9"
        ap-south-1     = "ami-4a90fa25"
        sa-east-1      = "ami-d952c7b5"
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
