variable "key_name" {
  default = "devops"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-053b0d53c279acc90" # Ubuntu 22.04 en us-east-1
}

variable "acm_certificate_arn" {
  description = "ARN del certificado SSL de ACM para el ALB"
  type        = string
}
