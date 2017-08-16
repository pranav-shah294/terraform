provider "aws" {
        access_key = ""
        secret_key = ""
        region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
        cidr_block = "10.0.0.0/16"
}


resource "aws_internet_gateway" "default" {
        vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
        route_table_id = "${aws_vpc.default.main_route_table_id}"
        destination_cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"

}


resource "aws_subnet" "public" {
        vpc_id = "${aws_vpc.default.id}"
        cidr_block = "10.0.1.0/24"
        map_public_ip_on_launch = true

}

resource "aws_security_group" "web" {
        name = "instance sg"
        description = "used in instance"
        vpc_id = "${aws_vpc.default.id}"


ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}

egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

}
}


resource "aws_instance" "web" {

        instance_type = "t2.micro"
        ami = "ami-10918173"
        vpc_security_group_ids = ["${aws_security_group.web.id}"]
        subnet_id = "${aws_subnet.public.id}"
}



