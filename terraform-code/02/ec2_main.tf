terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Main Code
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.access_secret
}


resource "aws_instance" "myec2" {
  ami = var.ami
  # If dev && eu-west-2 = t3.micro, else = t3.small
  instance_type = var.environment == "dev" && var.region == "eu-west-2" ? "t3.micro" : "t3.small"
  count = var.environment == "dev" ? 3 : 10

  tags = {
    Name = "my-ec2-A${1 + count.index}"
  }
}


# AWS Security Group
resource "aws_security_group" "terraform_firewall" {
  name        = "terraform-firewall"
  description = "Managed from terraform"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.terraform_firewall.id
  cidr_ipv4         = "${aws_eip.elastic_ip.public_ip}/32"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.terraform_firewall.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraform_firewall.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.terraform_firewall.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Elastic IP
resource "aws_eip" "elastic_ip" {
  domain = "vpc"
}