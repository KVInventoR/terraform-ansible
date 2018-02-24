resource "aws_vpc" "vpc-jenkins" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"

  tags {
    Name = "vpc-jenkins"
  }
}

resource "aws_subnet" "vpc-jenkins-public-1" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.AWS_REGION}a"

  tags {
    Name = "vpc-jenkins-public-1"
  }
}

resource "aws_subnet" "vpc-jenkins-public-2" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.AWS_REGION}b"

  tags {
    Name = "vpc-jenkins-public-2"
  }
}

resource "aws_subnet" "vpc-jenkins-public-3" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.AWS_REGION}c"

  tags {
    Name = "vpc-jenkins-public-3"
  }
}

resource "aws_subnet" "vpc-jenkins-private-1" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.AWS_REGION}a"

  tags {
    Name = "vpc-jenkins-private-1"
  }
}

resource "aws_subnet" "vpc-jenkins-private-2" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.AWS_REGION}b"

  tags {
    Name = "vpc-jenkins-private-2"
  }
}

resource "aws_subnet" "vpc-jenkins-private-3" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.AWS_REGION}c"

  tags {
    Name = "vpc-jenkins-private-3"
  }
}

resource "aws_internet_gateway" "vpc-jenkins-gw" {
  depends_on = ["aws_vpc.vpc-jenkins"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"

  tags {
    Name = "vpc-jenkins"
  }
}

resource "aws_route_table" "vpc-jenkins-public" {
  depends_on = ["aws_internet_gateway.vpc-jenkins-gw"]
  vpc_id = "${aws_vpc.vpc-jenkins.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-jenkins-gw.id}"
  }

  tags {
    Name = "vpc-jenkins-public-1"
  }
}

resource "aws_route_table_association" "vpc-jenkins-public-1-a" {
  subnet_id = "${aws_subnet.vpc-jenkins-public-1.id}"
  route_table_id = "${aws_route_table.vpc-jenkins-public.id}"
}

resource "aws_route_table_association" "vpc-jenkins-public-2-b" {
  subnet_id = "${aws_subnet.vpc-jenkins-public-2.id}"
  route_table_id = "${aws_route_table.vpc-jenkins-public.id}"
}

resource "aws_route_table_association" "vpc-jenkins-public-3-c" {
  subnet_id = "${aws_subnet.vpc-jenkins-public-3.id}"
  route_table_id = "${aws_route_table.vpc-jenkins-public.id}"
}
