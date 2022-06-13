variable "image_id" {
    type = string
    default = "ami-0022f774911c1d690"
}

variable "vpc_cidr" {
    type = string
    default = "10.10.0.0/16"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}
