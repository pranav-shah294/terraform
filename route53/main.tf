provider "aws" {
        access_key = "YQ"
        secret_key = "b92"
        region = "${var.aws_region}"
}

variable "vpc_id" {
    type = "string"
    default = "vpc-988"
}

variable "subnet_id" {
    type = "string"
    default = "subnet-07"
}

variable "route53_zone_id" {
    type = "string"
    default = "ZFC7ZT1P"
}

variable "key_pair" {
    type = "string"
    default = "pranav"
}

resource "aws_instance" "web" {

        instance_type = "t2.micro"
        ami = "ami-0cfcdb69"
        subnet_id = "${var.subnet_id}"
        vpc_security_group_ids = ["sg-c"]
        key_name = "${var.key_pair}"
        user_data = <<HEREDOC
        #!/bin/bash
        sudo hostnamectl set-hostname --static pranav01.me
        HEREDOC
}


resource "aws_instance" "api" {

        instance_type = "t2.micro"
        ami = "ami-0cfcdb69"
        vpc_security_group_ids = ["sg-f9c"]
        subnet_id = "${var.subnet_id}"
        key_name = "${var.key_pair}"
        user_data = <<HEREDOC
        #!/bin/bash
        sudo hostnamectl set-hostname --static pranav02.me
        HEREDOC
}



resource "aws_route53_zone_association" "primary" {
  zone_id = "${var.route53_zone_id}"
  vpc_id  = "${var.vpc_id}"
}

resource "aws_route53_record" "www" {
  zone_id = "${var.route53_zone_id}"
  name    = "pranav1"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.web.private_ip}"]
}


resource "aws_route53_record" "api" {
  zone_id = "${var.route53_zone_id}"
  name    = "pranav2"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.api.private_ip}"]
}
