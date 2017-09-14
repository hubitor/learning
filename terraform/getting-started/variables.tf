variable "aws_profile" {}

variable "region" {
  default = "us-east-1"
}

variable "key_name" {}

variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-east-2" = "ami-cc7551a9"
    "us-west-2" = "ami-4b32be2b"
  }
}
