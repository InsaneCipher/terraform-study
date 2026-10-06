terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


# Variables
variable "access_key" {
  type = string
  description = "EC2 Key"
}

variable "access_secret" {
  type = string
  description = "EC2 Secret"
}

variable "ami" {
  type = string
  description = "AMI"
}


# Main Code
provider "aws" {
  region = "eu-west-2"
  access_key = var.access_key
  secret_key = var.access_secret
}


resource "aws_instance" "myec2" {
  ami = var.ami
  instance_type = "t3.micro"

  tags = {
    Name = "my-first-ec2"
  }
}