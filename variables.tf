variable "aws_region" {
  default = "us-east-1"
}

variable "aws_ami" {
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair_name" {
  default = "vockey"
}