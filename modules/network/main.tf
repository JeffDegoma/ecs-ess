//exported to module ecs_cluster

// vpc
resource "aws_vpc" "seton_dev" {
 cidr_block      =   "${var.vpc_cidr}"
 tags{Name            =    "seton_dev"}
}

//igw
resource "aws_internet_gateway" "igw" {
  vpc_id                =       "${aws_vpc.seton_dev.id}"
}


//subnets
resource "aws_subnet" "public" {
  count                 =       "${length(var.subnet_cidr)}"
  vpc_id                =      "${aws_vpc.seton_dev.id}"
  cidr_block            =       "${element(var.subnet_cidr, count.index)}"
  availability_zone     =       "${element(var.az, count.index)}"
  map_public_ip_on_launch = true
}


//route tables
resource "aws_route_table" "public_route" {
    vpc_id                =       "${aws_vpc.seton_dev.id}"
    route {
        cidr_block        =       "0.0.0.0/0"
        gateway_id        =       "${aws_internet_gateway.igw.id}"
    }
    tags {
        Name          =       "public route"
    }
}


resource "aws_route_table_association" "public_route" {
    count               =       "${length(var.subnet_cidr)}"
    subnet_id           =       "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id      =       "${aws_route_table.public_route.id}"
}