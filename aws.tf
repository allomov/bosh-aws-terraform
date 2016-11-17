/*
  AWS Provider
*/
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

/*
  Create the VPC
*/
resource "aws_vpc" "bosh_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.prefix}_bosh_vpc"
    }
}

/*
  Public Subnet
*/
resource "aws_subnet" "vpc_public_subnet" {
    vpc_id = "${aws_vpc.bosh_vpc.id}"
    map_public_ip_on_launch = true

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.aws_az}"

    tags {
        Name = "${var.prefix}_bosh_public_subnet"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "vpc_private_subnet" {
    vpc_id = "${aws_vpc.bosh_vpc.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.aws_az}"

    tags {
        Name = "${var.prefix}_bosh_private_subnet"
    }
}

/*
  Create the Elastic IP
*/
resource "aws_eip" "bosh_eip" {
    vpc = true
}

/*
  NAT Gateway
 */
resource "aws_nat_gateway" "vpc_nat_gateway" {
    allocation_id = "${aws_eip.bosh_eip.id}"
    subnet_id = "${aws_subnet.vpc_public_subnet.id}"
}

/*
  Internet Gateway
 */
resource "aws_internet_gateway" "vpc_internet_gateway" {
    vpc_id = "${aws_vpc.bosh_vpc.id}"
    tags {
        Name = "${var.prefix}_bosh_internet_gateway"
    }
}

/*
  Public routing table
*/
resource "aws_route_table" "vpc_public_subnet_router" {
    vpc_id = "${aws_vpc.bosh_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.vpc_internet_gateway.id}"
    }

    tags {
        Name = "${var.prefix}_bosh_public_subnet_router"
    }
}

resource "aws_route_table_association" "vpc_public_subnet_router_association" {
    subnet_id = "${aws_subnet.vpc_public_subnet.id}"
    route_table_id = "${aws_route_table.vpc_public_subnet_router.id}"
}

/*
Private Routing table
 */
resource "aws_route_table" "vpc_private_subnet_router" {
    vpc_id = "${aws_vpc.bosh_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.vpc_nat_gateway.id}"
    }

    tags {
        Name = "${var.prefix}_bosh_private_subnet_route"
    }
}

resource "aws_route_table_association" "vpc_private_subnet_router_association" {
    subnet_id = "${aws_subnet.vpc_private_subnet.id}"
    route_table_id = "${aws_route_table.vpc_private_subnet_router.id}"
}

resource "aws_security_group" "ssh_only" {
  vpc_id = "${aws_vpc.bosh_vpc.id}"
  description = "Allow only SSH"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix}_bosh_jumpbox_sg"
  }
}

resource "aws_instance" "bosh_jumpbox" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.ssh_only.id}"]
    subnet_id = "${aws_subnet.vpc_public_subnet.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.prefix}_bosh_jumpbox"
    }

    connection {
      user = "${var.jumpbox_user}"
      private_key = "${file("${var.aws_key_path}")}"
    }


}

# Outputs
output "jumpbox_ip" {
  value = "${aws_instance.bosh_jumpbox.public_ip}"
}

output "bosh_jumpbox_ip" {
  value = "${aws_instance.bosh_jumpbox.public_ip}"
}
