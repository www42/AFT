terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# ssh-keygen -f foo3 -t rsa -b 2048 -m pem -C 'foo3@example.com' -P ''
# chmod 400 foo3
# openssl rsa -in foo3 -pubout -outform DER 2>/dev/null | openssl md5 -c
# cat foo3.pub

resource "aws_key_pair" "foo3key" {
  key_name   = "foo3key"
  public_key = ""
}

# aws ec2 describe-key-pairs --filters Name=key-name,Values=foo3key