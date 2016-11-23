/*
  Create the VPC
*/
resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.prefix}_main"
    }
}

/*
  Public Subnet
*/
resource "aws_subnet" "vpc_public_subnet" {
    vpc_id = "${aws_vpc.main.id}"
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
    vpc_id = "${aws_vpc.main.id}"

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
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "${var.prefix}_bosh_internet_gateway"
    }
}

/*
  Public routing table
*/
resource "aws_route_table" "vpc_public_subnet_router" {
    vpc_id = "${aws_vpc.main.id}"

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
    vpc_id = "${aws_vpc.main.id}"

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
  vpc_id = "${aws_vpc.main.id}"
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
    Name = "${var.prefix}_ssh_only_sg"
  }
}
