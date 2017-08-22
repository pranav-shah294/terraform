provider "aws" {
        access_key = "AKIAFFQ"
        secret_key = "pBuMDHPKg"
        region = "${var.aws_region}"
}

variable "vpc_id" {
    type = "string"
    default = "vpc-c90"
}

variable "subnet_id" {
    type = "string"
    default = "subnet989"
}

variable "route53_zone_id" {
    type = "string"
    default = "Z2286V52"
}

variable "key_pair" {
    type = "string"
    default = "terraform-virginia"
}

resource "aws_instance" "svc" {

        instance_type = "t2.micro"
        ami = "ami-c3cff0b8"
        subnet_id = "${var.subnet_id}"
        vpc_security_group_ids = ["sg-d22"]
        key_name = "${var.key_pair}"
        user_data = <<HEREDOC
#!/bin/bash
sudo hostname svc01.aws01..com
HEREDOC
}


resource "aws_instance" "dst" {

        instance_type = "t2.micro"
        ami = "ami-c3cff0b8"
        vpc_security_group_ids = ["sg-a2"]
        subnet_id = "${var.subnet_id}"
        key_name = "${var.key_pair}"
        user_data = <<HEREDOC
#!/bin/bash
sudo hostname dst01.aws01..com
HEREDOC
}




resource "aws_route53_record" "svc" {
  zone_id = "${var.route53_zone_id}"
  name    = "svc01.aws01"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.svc.private_ip}"]
}


resource "aws_route53_record" "dst" {
  zone_id = "${var.route53_zone_id}"
  name    = "dst01.aws01"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.dst.private_ip}"]
}
