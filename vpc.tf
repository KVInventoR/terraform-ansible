# VPC CONFIGURATION
# =============================================================================
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "main"
  }
}

# VPC Public subnets
# =============================================================================
# Subnet
resource "aws_subnet" "main-public-1" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags {
    Name = "main-public-1"
  }
}

# Subnets
resource "aws_subnet" "main-public-2" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}b"

  tags {
    Name = "main-public-2"
  }
}

# Subnets
resource "aws_subnet" "main-public-3" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}c"

  tags {
    Name = "main-public-3"
  }
}

# VPC Private subnets
# =============================================================================
# Subnets
resource "aws_subnet" "main-private-1" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags {
    Name = "main-private-1"
  }
}

# Subnets
resource "aws_subnet" "main-private-2" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}b"

  tags {
    Name = "main-private-2"
  }
}

# Subnets
resource "aws_subnet" "main-private-3" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}c"

  tags {
    Name = "main-private-3"
  }
}

# VPC Internet gateway
# =============================================================================
# Internet gateway
resource "aws_internet_gateway" "main-gw" {
  depends_on = ["aws_vpc.main"]
  vpc_id     = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

# Route tables
resource "aws_route_table" "main-public" {
  depends_on = ["aws_internet_gateway.main-gw"]
  vpc_id     = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }

  tags {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = "${aws_subnet.main-public-1.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-2-b" {
  subnet_id      = "${aws_subnet.main-public-2.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-3-c" {
  subnet_id      = "${aws_subnet.main-public-3.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}
