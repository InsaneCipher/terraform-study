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

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "eu-west-2"
}