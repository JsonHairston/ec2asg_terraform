terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Outputs
# output "web_instance_ip" {
#     value = aws_autoscaling_group.terraform_asg.public_ip
# }