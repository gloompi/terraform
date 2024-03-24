provider "aws" {
  region = "eu-west-1"
}

# We can instruct terraform to use certain provider version during install
# If no lock file is present
#
# terraform {
#   required_providers {
#     aws = {
#       version = "~> 3.46"
#     }
#   }
# }

# We can use more than one instances of the same resource

provider "aws" {
  region = "us-east-2"
  alias = "ohio"
}

# and choose which provider to use in the resource

resource "aws_vpc" "frankfurt_vpc" {
  cidr_block = "10.0.0.0/16"
  # default provider will be used
}

resource "aws_vpc" "ohio_vpc" {
  cidr_block = "10.1.0.0/16"
  provider = aws.ohio
}

# ---- Resources -----

resource "aws_s3_bucket" "first_bucket" {
  bucket = "gloompi-terraform-bucket"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  name = "Example security group"
}

resource "aws_security_group_rule" "http_in" {
  protocol = "tcp"
  security_group_id = aws_security_group.my_security_group.id
  from_port = 80
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tls_in" {
  protocol = "tcp"
  security_group_id = aws_security_group.my_security_group.id
  from_port = 443
  to_port = 443
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}
